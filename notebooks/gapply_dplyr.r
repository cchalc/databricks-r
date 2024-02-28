# Databricks notebook source
library(SparkR)
library(sparklyr)
library(dplyr)

# COMMAND ----------

# MAGIC %fs ls /databricks-datasets/airlines/

# COMMAND ----------

# Read data into Spark
sc <- sparklyr::spark_connect(method = "databricks")

# Read in the airlines dataset
path <- "/databricks-datasets/asa/airlines"
df <- spark_read_csv(sc, name = "airlines", path = path)

# COMMAND ----------

## Take a subset of the columns
subsetDF <- dplyr::select(sparklyAirlines, UniqueCarrier, Month, DayofMonth, Origin, Dest, DepDelay, ArrDelay) 

## Focus on the month of December, Christmas Eve
holidayTravelDF <- dplyr::filter(subsetDF, Month == 12, DayOfMonth == 24)

# COMMAND ----------

## Add a new column for each group and return the results
resultsDF <- sparklyr::spark_apply(holidayTravelDF,
                                  group_by = "UniqueCarrier",
                                  function(e){
                                    # 'e' is a data.frame containing all the rows for each distinct UniqueCarrier
                                    one_carrier_df <- data.frame(newcol = paste0(unique(e$UniqueCarrier), "_new"))
                                    one_carrier_df
                                  }, 
                                   # Specify schema
                                   columns = list(
                                   UniqueCarrier = "string",
                                   newcol = "string"),
                                   # Do not copy packages to each worker
                                   packages = F)
head(resultsDF)
