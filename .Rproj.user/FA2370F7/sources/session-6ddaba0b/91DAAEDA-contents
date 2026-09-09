# Tidies SSB Table 08806, exports to the US, SITC 1-digit, monthly.
# https://www.ssb.no/en/statbank/table/08806

source("scripts/00_helpers.R")

data_exports <- read_ssb_export("data/raw/exports_us_monthly.xlsx")

dir.create("data/processed", showWarnings = FALSE, recursive = TRUE)
write_csv(data_exports, "data/processed/exports_us_tidy.csv")
