# Norway's Exports to the U.S., and What the New Tariff Puts at Stake

An applied data-analysis case study in R and Quarto, using Statistics
Norway (SSB) trade data and a live Norges Bank exchange rate feed to
examine Norwegian exports to the United States after the U.S. imposed a
12.5% additional tariff on Norwegian goods on 24 July 2026.

**Read the write-up:** [birktyssebotn.github.io/norus-tariffs-case](https://birktyssebotn.github.io/norus-tariffs-case/)

Alternatively, read [`case-study.pdf`](case-study.pdf), or render
[`case-study.qmd`](case-study.qmd) yourself with Quarto.

## Repository structure

```
.
├── case-study.qmd                    # source (renders to index.html)
├── index.html                        # rendered output, published via GitHub Pages
├── case-study.pdf                    # static PDF version
├── scripts/
│   ├── 00_helpers.R                  # shared SSB parsing + STL decomposition
│   ├── 01_wrangle_exports.R          # US exports -> tidy CSV
│   ├── 02_wrangle_share_of_total.R   # US share of Norway's total exports
│   ├── 03_wrangle_seasonal.R         # seasonal baseline, US
│   └── 05_wrangle_exchange_rate.R    # pulls NOK/USD live from Norges Bank's API
├── data/
│   ├── raw/                          # raw SSB downloads (not tracked)
│   └── processed/                    # tidy CSVs used by the case study
└── figs/                             # (optional) exported PNGs of key figures
```

## Data

- Statistics Norway, [Table 08806](https://www.ssb.no/en/statbank/table/08806)
  (external trade in goods, by commodity group, country, month and
  imports/exports), licensed under
  [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).
- Norges Bank, [open data API](https://www.norges-bank.no/en/topics/statistics/open-data/),
  series `EXR/M.USD.NOK.SP`, queried live at run time (not a downloaded
  file).

Three SSB extracts, same commodity/exports settings unless noted:

| File | Country | Months |
|---|---|---|
| `data/raw/exports_us_monthly.xlsx` | United States | Jan 2025 to present |
| `data/raw/exports_total_monthly.xlsx` | All countries | Jan 2025 to present |
| `data/raw/exports_us_monthly_long.xlsx` | United States | Jan 2018 to present |

## Reproducing this analysis

1. Download the three SSB extracts above (see the header comments in
   each `scripts/0N_*.R` file for exact filter selections) and save them
   under `data/raw/` with the filenames shown.
2. Run, in order: `01_wrangle_exports.R`, `02_wrangle_share_of_total.R`,
   `03_wrangle_seasonal.R`, `05_wrangle_exchange_rate.R`. Each sources
   `00_helpers.R` automatically. `05` requires an internet connection at
   run time, since it queries Norges Bank directly.
3. Render `case-study.qmd` (in RStudio: **Render**; from the terminal:
   `quarto render case-study.qmd`). This produces `index.html`.

## Tools

R, tidyverse, readxl, patchwork, Quarto. Seasonal decomposition uses
`stats::stl()` (base R, no extra package).

## License

MIT (see `LICENSE`). Underlying data is licensed separately by its
sources, per the terms linked above.
