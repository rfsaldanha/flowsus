library(duckdb)
library(duckplyr)

con <- dbConnect(duckdb(), dbdir = "teste_pcdas_sih.duckdb", read_only = FALSE)

sih_tbl <- dplyr::tbl(con, "sih8")

res <- sih_tbl |>
  filter(def_ident == "Normal") |>
  mutate(
    year = year(dt_inter),
    month = month(dt_inter)
  ) |>
  summarise(
    freq = n(),
    .by = c(year, month, cod_res, cod_int)
  ) |>
  collect()
