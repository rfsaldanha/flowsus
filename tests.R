library(microdatasus)
raw <- fetch_datasus(year_start = 2020, month_start = 1, year_end = 2020, month_end = 1, uf = "RJ", information_system = "SIH-RD") 

sih <- process_sih(raw)

library(rpcdas)

list_pcdas_tables()

query <- "SELECT TOP 100 res_codigo_adotado AS cod_res, int_MUNCOD AS cod_int, COUNT(*) AS freq 
FROM \"datasus-sih\" 
WHERE dt_inter = '2020-01-01'
AND def_ident = 'Normal' 
AND def_car_int = 'Urgência'
GROUP BY cod_res, cod_int"

#WHERE dt_inter = '2020-01-01'

res <- rpcdas::generic_pcdas_query(sql_query = query)

library(duckdb)

con <- dbConnect(duckdb(), dbdir = "pcdas_sih.duckdb", read_only = FALSE)

dbExecute(con, "CREATE TABLE sih AS 
          SELECT res_codigo_adotado AS cod_res, 
          int_MUNCOD AS cod_int 
          dt_inter, def_ident, def_car_int 
          FROM '/media/raphael/lacie/pcdas_sih/*.csv'")

dbGetQuery(con, "SELECT * FROM sih3")

dbDisconnect(con)

