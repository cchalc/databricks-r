FROM databricksruntime/minimal:9.x

# Suppress interactive configuration prompts
ENV DEBIAN_FRONTEND=noninteractive

# We add RStudio's debian source to install the latest r-base version (4.1)
# We are using the more secure long form of pgp key ID of marutter@gmail.com
# based on these instructions (avoiding firewall issue for some users):
# https://cran.rstudio.com/bin/linux/ubuntu/#secure-apt
RUN apt-get update \
  && apt-get install --yes software-properties-common apt-transport-https \
  && add-apt-repository -y 'deb [arch=amd64,i386] https://cran.rstudio.com/bin/linux/ubuntu bionic-cran40/' \
  && apt-get update \
  && apt-get install --yes \
    libssl-dev \
    r-base \
    r-base-dev \
    libudunits2-dev \
    libgdal-dev \
    libgeos-dev \
    libproj-dev \
  && add-apt-repository -r 'deb [arch=amd64,i386] https://cran.rstudio.com/bin/linux/ubuntu bionic-cran40/' \
  && apt-key del E298A3A825C0D65DFD57CBB651716619E084DAB9 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install the geospatial packages
RUN R -e "remotes::install_github("rspatial/terra")"

# hwriterPlus is used by Databricks to display output in notebook cells
# Rserve allows Spark to communicate with a local R process to run R code
RUN R -e "install.packages(c('hwriterPlus'), repos='https://mran.revolutionanalytics.com/snapshot/2017-02-26')" \
 && R -e "install.packages(c('htmltools'), repos='https://cran.microsoft.com/')" \
 && R -e "install.packages('Rserve', repos='http://rforge.net/')"

# Additional instructions to setup rstudio. If you dont need rstudio, you can 
# omit the below commands in your docker file. Even after this you need to use
# an init script to start the RStudio daemon (See README.md for details.)

# Databricks configuration for RStudio sessions.
# Added Sys.setenv(DOWNLOAD_STATIC_LIBV8 = 1) for the RStan install
COPY Rprofile.site /usr/lib/R/etc/Rprofile.site

#RUN R -e "install.packages('rstan', repos = 'https://cloud.r-project.org/', dependencies = TRUE)"

# Rstudio installation.
RUN apt-get update \
 # Installation of rstudio in databricks needs /usr/bin/python.
 && apt-get install -y python \
 # Install gdebi-core.
 && apt-get install -y gdebi-core \
 # Download rstudio 1.2 package for ubuntu 18.04 and install it.
 && apt-get install -y wget \
 && wget https://download2.rstudio.org/server/bionic/amd64/rstudio-server-1.2.5042-amd64.deb -O rstudio-server.deb \
 && gdebi -n rstudio-server.deb \
 && rm rstudio-server.deb
