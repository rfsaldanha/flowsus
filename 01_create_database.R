library(duckdb)

con <- dbConnect(duckdb(), dbdir = "pcdas_sih.duckdb", read_only = FALSE)

dbExecute(con, "CREATE TABLE sih AS 
          SELECT res_codigo_adotado AS cod_res, 
          int_MUNCOD AS cod_int, 
          DT_INTER AS dt_inter, def_ident, def_car_int 
          FROM read_csv('/media/raphael/lacie/pcdas_sih/csv/*.csv',
          delim = ',',
          header = true,
          dateformat = '%Y%m%d',
          types = {'res_codigo_adotado': 'VARCHAR',
          'int_MUNCOD': 'VARCHAR',
          'dt_inter': 'DATE',
          'def_ident': 'VARCHAR',
          'def_car_int': 'VARCHAR'}
          )")

dbGetQuery(con, "SELECT * FROM sih LIMIT 10")

dbDisconnect(con)