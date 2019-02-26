#devtools::install_github("timelyportfolio/parcoords")
packages.used=c("shiny", "plotly", "shinydashboard", "leaflet","DT", "shinyWidgets", "scales", "leaflet.extras")

# check packages that need to be installed.
packages.needed=setdiff(packages.used, 
                        intersect(installed.packages()[,1], 
                                  packages.used))
# install additional packages
if(length(packages.needed)>0){
  install.packages(packages.needed, dependencies = TRUE,repos = "http://cran.us.r-project.org")
}

library(shiny)
library(maps)
library(leaflet)
library(DT)
library(shinydashboard)
library(plotly)
library(shinyWidgets)
library(scales)
library(leaflet.extras)



#data = read.csv("./data/processed_data_map.csv")
#load("./data/processed_data_map.csv")