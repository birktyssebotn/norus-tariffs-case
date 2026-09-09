# Pulls the NOK/USD monthly exchange rate directly from Norges Bank's
# open data API, series EXR/M.USD.NOK.SP (monthly average spot rate,
# NOK per 1 USD). Live query, not a static file, so this always reflects
# whatever Norges Bank has published as of when the script runs.

library(readr)
library(dplyr)
library(lubridate)

fx_url <- paste0(
  "https://data.norges-bank.no/api/data/EXR/M.USD.NOK.SP",
  "?format=csv&bom=include&startPeriod=2018-01-01&endPeriod=", Sys.Date()
)

fx <- read_delim(fx_url, delim = ";", show_col_types = FALSE) %>%
  transmute(date = ym(TIME_PERIOD), usd_nok = OBS_VALUE)

dir.create("data/processed", showWarnings = FALSE, recursive = TRUE)
write_csv(fx, "data/processed/usd_nok_tidy.csv")
