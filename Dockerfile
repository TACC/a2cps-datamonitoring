FROM rocker/tidyverse:latest

RUN apt-get update &&\
   apt-get install build-essential libcurl4-gnutls-dev libssl-dev libxml2-dev libgit2-dev libxt-dev libcairo2-dev libssh2-1-dev -y &&\
   mkdir -p /var/lib/shiny-server/bookmarks/shiny

RUN R -e "install.packages('devtools')"

RUN R -e "install.packages(c('shiny', 'shinydashboard','DT','dplyr','ggplot2','gridExtra','shinythemes','parsedate','remotes', 'tidyverse','httr','jsonlite','scales','forcats','ggplot2 ','DT','plotly','ggthemes','Hmisc','kableExtra','here','hablar','lubridate','janitor','UpSetR'), repos='http://cran.rstudio.com/')"

RUN chmod -R 777 /usr/local/lib/R/etc
COPY Rprofile.site /usr/local/lib/R/etc/Rprofile.site
RUN chmod -R 777 /usr/local/lib/R/etc/Rprofile.site
RUN addgroup --system app \
    && adduser --system --ingroup app app
WORKDIR /home/app
RUN chown app:app -R /home/app
ADD src /home/app/
USER app
EXPOSE 8950
CMD ["R", "-e", "shiny::runApp('/home/app', host = '0.0.0.0', port=8950)"]
