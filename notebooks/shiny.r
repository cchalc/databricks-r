# Databricks notebook source


# COMMAND ----------

# Use sparklyr to read the airlines dataset from 2007.
airlines_sdf <- sparklyr::spark_read_csv(sc   = sc,
                                         name = "airlines",
                                         path = "/databricks-datasets/asa/airlines/2007.csv")

# Print the loaded dataset's class name.
# cat("Class of sparklyr object: ", class(airlines_sdf))

# COMMAND ----------


