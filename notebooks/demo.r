# Databricks notebook source
library(SparkR)
library(sparklyr)
library(dplyr)

# COMMAND ----------

sc <- spark_connect(method = "databricks")

# COMMAND ----------

sql("use catalog cjc")

# COMMAND ----------

sql("use schema scratch")

# COMMAND ----------

df <- tableToDF("cjc.scratch.books")
display(df)

# COMMAND ----------

books_tbl <- tbl(sc, "books")

# COMMAND ----------

# Aggregate and save to unity catalog
books_agg_tbl <- books_tbl %>%
  group_by(author) %>%
  summarize(n_books = n()) %>%
  spark_write_table(name = "books_agg", mode = "overwrite",
                    catalog_database = "scratch",
                    catalog_table = "books_agg")

# COMMAND ----------

collect(sdf_sql(sc, "SELECT * FROM books_agg"))


# COMMAND ----------

fromTable <- spark_read_table(
  sc   = sc,
  name = "books_agg"
)

collect(fromTable)


# COMMAND ----------

display(fromTable)
