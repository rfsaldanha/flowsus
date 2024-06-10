library(duckdb)
library(duckplyr)

con <- dbConnect(duckdb(), dbdir = "pcdas_sih.duckdb", read_only = TRUE)

sih_tbl <- dplyr::tbl(con, "sih")

sih_tbl |> tally()
# 187 735 977

sih_tbl |>
  head() |>
  collect()

res_geral <- sih_tbl |>
  filter(def_ident == "Normal") |>
  filter(year(dt_inter) >= 2008 & year(dt_inter) <= 2023) |>
  mutate(
    year = year(dt_inter),
    month = month(dt_inter)
  ) |>
  summarise(
    freq = n(),
    .by = c(year, month, cod_res, cod_int)
  ) |>
  collect()

res_eletivo <- sih_tbl |>
  filter(def_ident == "Normal") |>
  filter(def_car_int == "Eletivo") |>
  filter(year(dt_inter) >= 2008 & year(dt_inter) <= 2023) |>
  mutate(
    year = year(dt_inter),
    month = month(dt_inter)
  ) |>
  summarise(
    freq = n(),
    .by = c(year, month, cod_res, cod_int)
  ) |>
  collect()

res_urgencia <- sih_tbl |>
  filter(def_ident == "Normal") |>
  filter(def_car_int == "Urgência") |>
  filter(year(dt_inter) >= 2008 & year(dt_inter) <= 2023) |>
  mutate(
    year = year(dt_inter),
    month = month(dt_inter)
  ) |>
  summarise(
    freq = n(),
    .by = c(year, month, cod_res, cod_int)
  ) |>
  collect()

dbDisconnect(con)
