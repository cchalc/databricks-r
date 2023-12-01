# Databricks notebook source
install.packages("devtools")
library(devtools)
install_github("databrickslabs/databricks-sdk-r")

# COMMAND ----------

require(databricks)

# set credentials
db_token = dbutils.secrets.get("cjc", "pat_e2d")
db_workspace = "https://e2-demo-field-eng.cloud.databricks.com"

# authenticate client
client <- DatabricksClient(
  host=db_workspace,
  token=db_token
)
# test


# COMMAND ----------

# client <- DatabricksClient()
clustersList(client)[, "cluster_name"]


# COMMAND ----------

require(databricks)

# client <- DatabricksClient()

job_name <- readline("cjc_r_rjob")
description <- readline("rsdk demo")
existing_cluster_id <- readline("1201-073329-prhqpoky")
notebook_path <- readline("/Repos/christopher.chalcraft@databricks.com/databricks-r/notebooks/demo")
task_key <- readline("my task key")

print("Attempting to create the job. Please wait...")

notebook_task <- list(
  notebook_path = notebook_path,
  source = "WORKSPACE"
)

job_task <- list(
  task_key = task_key,
  description = description,
  existing_cluster_id = existing_cluster_id,
  notebook_task = notebook_task
)

response <- jobsCreate(
  client,
  name = job_name,
  tasks = list(job_task)
)

# Get the workspace URL to be used in the following results message.
get_client_debug <- strsplit(client$debug_string(), split = "host=")
get_host <- strsplit(get_client_debug[[1]][2], split = ",")
host <- get_host[[1]][1]

# Make sure the workspace URL ends with a forward slash.
if (endsWith(host, "/")) {
} else {
  host <- paste(host, "/", sep = "")
}

print(paste(
  "View the job at ",
  host,
  "#job/",
  response$job_id,
  sep = "")
)

# COMMAND ----------

require(databricks)

# client <- DatabricksClient()

job_name <- readline("cjc_r_rjob")
description <- readline("rsdk demo")
existing_cluster_id <- "1201-073329-prhqpoky"
notebook_path <- readline("/Repos/christopher.chalcraft@databricks.com/databricks-r/notebooks/demo")
task_key <- readline("my_task_key")

print("Attempting to create the job. Please wait...")

notebook_task <- list(
  notebook_path = notebook_path,
  source = "WORKSPACE"
)

job_task <- list(
  task_key = task_key,
  description = description,
  existing_cluster_id = existing_cluster_id,
  notebook_task = notebook_task
)

response <- jobsCreate(
  client,
  name = job_name,
  tasks = list(job_task)
)

# Get the workspace URL to be used in the following results message.
get_client_debug <- strsplit(client$debug_string(), split = "host=")
get_host <- strsplit(get_client_debug[[1]][2], split = ",")
host <- get_host[[1]][1]

# Make sure the workspace URL ends with a forward slash.
if (endsWith(host, "/")) {
} else {
  host <- paste(host, "/", sep = "")
}

print(paste(
  "View the job at ",
  host,
  "#job/",
  response$job_id,
  sep = "")
)

# COMMAND ----------


