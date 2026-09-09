# US exports as a share of Norway's total (all-country) exports, by industry.

source("scripts/00_helpers.R")

exports_us <- read_csv("data/processed/exports_us_tidy.csv", show_col_types = FALSE) %>%
  rename(exports_us_mill_nok = exports_mill_nok)

exports_total <- read_ssb_export("data/raw/exports_total_monthly.xlsx") %>%
  rename(exports_total_mill_nok = exports_mill_nok)

share_of_total <- exports_us %>%
  inner_join(exports_total, by = c("industry", "date")) %>%
  mutate(share_of_total = exports_us_mill_nok / exports_total_mill_nok)

dir.create("data/processed", showWarnings = FALSE, recursive = TRUE)
write_csv(share_of_total, "data/processed/exports_us_share_of_total.csv")
