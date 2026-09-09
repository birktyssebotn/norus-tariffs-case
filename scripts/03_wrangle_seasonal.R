# STL seasonal decomposition per industry (log scale), 2018-present.
# Flags months where the remainder exceeds 2 SD as out of normal range.
# Industry 9 (Other commodities) excluded: several months are 0 or "-"
# in the source data, which breaks the log transform.

source("scripts/00_helpers.R")

raw_long <- read_ssb_export("data/raw/exports_us_monthly_long.xlsx")
seasonal_data <- run_seasonal_by_industry(raw_long)

dir.create("data/processed", showWarnings = FALSE, recursive = TRUE)
write_csv(seasonal_data, "data/processed/exports_us_seasonal.csv")
