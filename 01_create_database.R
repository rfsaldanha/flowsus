library(duckdb)
library(dplyr)
library(glue)

con <- dbConnect(duckdb(), dbdir = "pcdas_sih.duckdb", read_only = FALSE)

dbExecute(con, "CREATE TABLE sih (
    cod_res VARCHAR,
    cod_int VARCHAR,
    dt_inter DATE,
    def_ident VARCHAR,
    def_car_int VARCHAR
)")

years <- 2008:2023

for(y in years){
  message(y)
  query <- glue("INSERT INTO sih 
          SELECT res_codigo_adotado AS cod_res, 
          int_MUNCOD AS cod_int, 
          DT_INTER AS dt_inter, def_ident, def_car_int 
          FROM read_csv('/media/raphael/lacie/pcdas_sih/csv/*[y]*.csv',
          delim = ',',
          header = true,
          dateformat = '%Y%m%d',
          types = {'res_codigo_adotado': 'VARCHAR',
          'int_MUNCOD': 'VARCHAR',
          'dt_inter': 'DATE',
          'def_ident': 'VARCHAR',
          'def_car_int': 'VARCHAR'},
          union_by_name = true
          )", .open = "[", .close = "]")
  
  dbExecute(con, query)
}


dbDisconnect(con)

