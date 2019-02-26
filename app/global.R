#devtools::install_github("timelyportfolio/parcoords")
packages.used=c("shiny", "plotly", "shinydashboard", "leaflet","DT", "shinyWidgets", "scales", "leaflet.extras","ggthemes","reshape2","dplyr","parcoords")

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
library(ggthemes)
library(reshape2)
library(dplyr)
library(parcoords)



#data = read.csv("./data/processed_data_map.csv")
#load("./data/processed_data_map.csv")
data_2 = read.csv("../output/processed_data_map_2.csv")
data = read.csv("../output/processed_data_map_1.csv")
data_v = read.csv("../output/processed_data_value_box.csv")
data_c = read.csv("../output/data_compare_3.csv",header = TRUE)
data_c$Unemployment.Rate <- data_c$Unemployment.Rate/100
basic = read.csv('../output/basic.csv', stringsAsFactors=FALSE)
academics = read.csv('../output/academics.csv', stringsAsFactors=FALSE)
act = read.csv('../output/act.csv', stringsAsFactors=FALSE)
sat = read.csv('../output/sat.csv', stringsAsFactors=FALSE) 
cost = read.csv('../output/cost.csv', stringsAsFactors=FALSE)
adm_rate = read.csv('../output/adm_rate.csv', stringsAsFactors=FALSE)