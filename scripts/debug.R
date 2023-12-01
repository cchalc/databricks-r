library(dplyr)
library(databricks)

client <- DatabricksClient(profile="DEFAULT")

running <- clustersList(client) %>% filter(state == 'RUNNING')
context <- commandExecutionCreate(client, cluster_id=running$cluster_id, language='python')
res <- commandExecutionExecute(client, cluster_id=running$cluster_id, context_id=context$id, language='sql', command='show tables')
res