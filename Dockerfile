# Dockerfile for DSDocker - a data science docker image including
#   - Jupyter and select packages
#   - Rstudio and select R packages
#
# Credentials:
#   - Jupyter
#       Password: jupyter
#   - RStudio
#       User name: rstudio
#       Password: rstudio
#

FROM ubuntu:16.04

MAINTAINER oshryb <oshryb@gmail.com>

# Install packages, python and python packages
RUN apt-get update && \
    apt-get install -y vim && \
    apt-get install -y python python3 && \
    apt-get install -y python-pip python3-pip && \ 
    pip install --upgrade pip && \ 
    pip install numpy scipy sklearn pandas matplotlib seaborn bokeh scrapy statsmodels && \
    pip3 install --upgrade pip && \
    pip3 install jupyter scipy sklearn pandas matplotlib seaborn bokeh scrapy statsmodels && \
    python2 -m pip install ipykernel && \
    python2 -m ipykernel install --user

# Install R and R packages
RUN echo "deb http://cran.rstudio.com/bin/linux/ubuntu xenial/" | tee -a /etc/apt/sources.list && \
    gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9 && \
    gpg -a --export E084DAB9 | apt-key add - && \
    apt-get update && \
    apt-get install -y r-base r-base-dev && \ 
    # Jupyter Kernel
    apt-get install -y libssl-dev zlib1g-dev libcurl4-openssl-dev && \
    R -e "install.packages('devtools',repos = 'http://cran.us.r-project.org')" && \
    R -e "devtools::install_github('IRkernel/IRkernel')" && \
    R -e "IRkernel::installspec()" && \
    # R Packages
    R -e "install.packages(c('ggplot2','dplyr', 'reshape2', 'caret', 'stringr', 'forecast'), repos = 'http://cran.us.r-project.org')" && \
    R -e "install.packages(c('dbplyr', 'devtools', 'docopt', 'doParallel', 'foreach', 'gridExtra', 'tidyverse'), repos = 'http://cran.us.r-project.org')"

# Install Rstudio 
RUN apt-get -y install gdebi && \ 
    curl -sS https://s3.amazonaws.com/rstudio-server/current.ver \
        | xargs -I {} curl -sS http://download2.rstudio.org/rstudio-server-{}-amd64.deb -o /tmp/rstudio.deb && \
    gdebi -n /tmp/rstudio.deb && \
    rm -rf /tmp/*
                 
RUN set -e && \ 
	useradd -m -d /home/rstudio rstudio && \
	echo rstudio:rstudio \
        | chpasswd
                 
# Create the data folder structure
RUN mkdir -p /data
               
# Expose ports
EXPOSE 8888 8787

# Copy and run ServiceUp
ADD ServiceUp.sh /ServiceUp.sh

# Command
CMD ["/bin/bash", "/ServiceUp.sh"] 
