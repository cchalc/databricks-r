# Databricks notebook source
library(sparklyr
library(broom)

# COMMAND ----------

# Read data into Spark
sc <- sparklyr::spark_connect(method = "databricks")


## Input columns we need for December only
featuresDF <- dplyr::filter(subsetDF, Month == 12) %>%
                dplyr::select(Origin, DepDelay, ArrDelay)

## Group the flights data by Origin, then estimate the Arrival Delay based on the Departure Delay
coefDF <- sparklyr::spark_apply(featuresDF,
                               group_by = "Origin",
                               function(e){
                                 # e = one_origin_df
                                 # e = an R dataframe associated with ONE distinct origin.
                                 e$ArrDelay <- as.numeric(e$ArrDelay)
                                 e$DepDelay <- as.numeric(e$DepDelay)
                                 broom::tidy(lm(ArrDelay ~ DepDelay, data = na.omit(e)))
                               },
                               packages = F)

head(coefDF)

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
