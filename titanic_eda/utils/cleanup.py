from pyspark.sql import SparkSession

def drop_tables():
  spark = SparkSession.builder.getOrCreate()
  
  spark.sql("""
  DROP TABLE passenger_demographic_features""")
  
  spark.sql("""
  DROP TABLE passenger_labels""")
  
  spark.sql("""
  DROP TABLE passenger_ticket_features""")
  
  print("Tables dropped.")