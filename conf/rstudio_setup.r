

install.packages(c("odbc", "DBI"), repos = "https://cran.microsoft.com/snapshot/2022-02-24/")

library(odbc)
library(DBI)

conn = dbConnect(
  drv = odbc(),
  dsn = "Databricks"
)

