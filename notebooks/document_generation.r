# Databricks notebook source

rmarkdown::find_pandoc(cache = FALSE)

# COMMAND ----------

require(devtools)

install_version(
  package = "renv",
  repos   = "http://cran.us.r-project.org"
)

# COMMAND ----------

renv::init(settings = list(external.libraries=.libPaths()))
.libPaths(c(.libPaths()[2], .libPaths()))

# COMMAND ----------

renv::install('tinytex')

# COMMAND ----------

tinytex::install_tinytex()


# COMMAND ----------

library(tinytex)
cat("\\documentclass{article}
\\begin{document}
Hello world!
\\end{document}", file = "test.tex")
tinytex::pdflatex("test.tex")


# COMMAND ----------

# MAGIC %sh ls
