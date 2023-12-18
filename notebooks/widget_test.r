# Databricks notebook source
# dbutils.widgets.removeAll()

# COMMAND ----------

dbutils.widgets.dropdown(
  name = "table",
  defaultValue = "table1",
  choices = list("table1", "table2", "table3")
)


# COMMAND ----------

table_name <- dbutils.widgets.get("table")
print(table_name)

# COMMAND ----------



# COMMAND ----------

# %python
# database_name = "cjc.scratch"
# df_table = spark.sql(f"show tables in {database_name}")
# table_names = [row.tableName for row in df_table.collect()]
# print(table_names)

# COMMAND ----------

# MAGIC %md ### list with SparkR

# COMMAND ----------

library(SparkR)
database_name <- "cjc.scratch"
sparkR.session(appName = "ListTables")
df_table <- sql(paste("SHOW TABLES IN", database_name))
table_names <- collect(select(df_table, "tableName"))$tableName
print(table_names)
