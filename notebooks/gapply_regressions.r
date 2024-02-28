# Databricks notebook source
#4 min install time? brutal
#install.packages('fixest')

# COMMAND ----------

# load libraries
library(dplyr)
library(fixest)
library(broom)
library(tidyr)
library(SparkR)

# COMMAND ----------

# Set seed for reproducibility.
set.seed(20230606)

# Create fake data of reasonable size ###
# individuals, assigned to companies, using 3 platforms, either treated or untreated.
sample.size <- 1e4
people <- base::data.frame(id=base::sample(1:sample.size, sample.size), 
                           treat=base::sample(0:1, sample.size, replace=T), 
                           company=base::sample(c("CRA", "Compass", "Databricks"), sample.size, replace=T),
                           platform=base::sample(c("GCP", "AWS", "Azure"), sample.size, replace=T))

# Observe outcome following a process in 2 periods.
data <- people %>% 
  crossing(base::data.frame(post = c(0, 1))) %>%
  dplyr::mutate(dbus = rbinom(2*sample.size, 1000, 0.5) + 30 * post + 10 * treat + 30*post*treat + 4*(company == "CRA") + 2*(company == "Compass") + 100*(company == "Databricks"))

# Convert to Spark DataFrame and display.
spark_data <- SparkR::createDataFrame(data)
display(spark_data)

# COMMAND ----------

# Define result schema
schema <- structType(structField("platform", "string"), 
                     structField("estimate", "double"),
                     structField("std.error", "double"),
                     structField("statistic", "double"),
                     structField("p.value", "double"),
                     structField("model", "string"),
                     structField("term", "string"),
                     structField("nobs", "integer"),
                     structField("fe_used", "string"),
                     structField("cluster_var", "string"))

# Call SparkR::gapply to build plan to run regression specification.
reg.results <- spark_data %>% 
  SparkR::gapply(cols = "platform",
                 function(key, e){
                    library(magrittr)
                    # Helper function to clean model output.
                    fixest.tidy <- function(fit) {
                      tidy_part <- broom::tidy(fit) %>% 
                        dplyr::mutate(model = deparse(fit$fml), 
                                      nobs = fit$nobs,
                                      fe_used = fit$fixef_vars,
                                      cluster_var = attributes(fit$cov.scaled)$type) %>%
                        dplyr::relocate(term, .after = model)

                      return(tidy_part)
                    }
                    # Estimate two fixed-effects models with clustered standard errors. Clean results.
                    res.df <- fixest::feols(c(dbus, log(dbus)) ~ post + treat + post:treat | company, 
                                            data = e, nthreads = 1, 
                                            cluster = ~company) %>%
                                    as.list() %>%
                                    lapply(fixest.tidy) %>%
                                    dplyr::bind_rows()
                    return(res.df)
                 },
                 schema = schema)

# COMMAND ----------

# Execute plan.
display(reg.results)

# COMMAND ----------


