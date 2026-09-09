library(readxl)
library(tidyverse)

# Parses one SSB Table 08806 export. Row 4 (month labels) becomes the
# header; row 5 ("Exports", repeated) and footnote/contact rows below the
# data get dropped by the industry filter, since only real SITC 1-digit
# rows start with a digit followed by a space.
#
# Sums across whatever countries were selected in the download, so a
# file with one country selected behaves exactly as before, and a file
# with several (e.g. a hand-picked set of EU members, since SSB has no
# single EU aggregate in this table) returns their combined total per
# industry-month.
read_ssb_export <- function(path) {
  raw <- read_excel(path, skip = 3)

  raw %>%
    rename(industry = 1, country = 2) %>%
    filter(str_detect(industry, "^[0-9] ")) %>%
    select(-country) %>%
    pivot_longer(cols = -industry, names_to = "month_raw", values_to = "exports_nok_1000") %>%
    mutate(
      exports_nok_1000 = as.numeric(exports_nok_1000),
      date = ym(str_replace(month_raw, "M", "-"))
    ) %>%
    filter(!is.na(date), !is.na(exports_nok_1000)) %>%
    group_by(industry, date) %>%
    summarise(exports_mill_nok = sum(exports_nok_1000) / 1000, .groups = "drop")
}

# STL decomposition (log scale) for one industry's time series. Requires
# a gap-free monthly series; returns NULL (with a warning) if the series
# has a gap, so the caller can drop that industry rather than crash.
decompose_seasonal <- function(df) {
  df <- df %>% arrange(date)

  n_expected <- interval(min(df$date), max(df$date)) %/% months(1) + 1
  if (nrow(df) != n_expected) {
    warning("Gap in series for ", unique(df$industry), " -- skipping.")
    return(NULL)
  }

  ts_log <- ts(
    log(df$exports_mill_nok),
    start = c(year(min(df$date)), month(min(df$date))),
    frequency = 12
  )

  comp <- as_tibble(stl(ts_log, s.window = "periodic")$time.series)

  df %>%
    mutate(
      trend = comp$trend,
      seasonal = comp$seasonal,
      remainder = comp$remainder,
      expected_mill_nok = exp(trend + seasonal),
      remainder_sd = sd(remainder),
      out_of_normal_range = abs(remainder) > 2 * remainder_sd
    )
}

# Runs decompose_seasonal() per industry, excluding any industry matching
# exclude_pattern (default: "9 Other commodities and transactions", too
# sparse/irregular for a seasonal pattern to mean anything).
run_seasonal_by_industry <- function(raw_long, exclude_pattern = "^9 ") {
  industries <- raw_long %>%
    distinct(industry) %>%
    filter(!str_detect(industry, exclude_pattern)) %>%
    pull(industry)

  raw_long %>%
    filter(industry %in% industries) %>%
    group_by(industry) %>%
    group_split() %>%
    map(decompose_seasonal) %>%
    bind_rows()
}
