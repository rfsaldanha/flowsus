library(duckdb)

con <- dbConnect(duckdb(), dbdir = "teste_pcdas_sih.duckdb", read_only = FALSE)

query <- "SELECT cod_res, cod_int, COUNT(*) AS freq 
FROM sih 
WHERE dt_inter = '2014-12-01'
AND def_ident = 'Normal' 
AND def_car_int = 'Urgência'
GROUP BY cod_res, cod_int"

dbGetQuery(con, query)
