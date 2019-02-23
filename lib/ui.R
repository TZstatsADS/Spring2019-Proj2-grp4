library(devtools)
library(plotly)
library(ggthemes)
library(shiny)
library(reshape2)
library(parcoords)
library(stringr)
library(RColorBrewer)
library(geosphere)
library(formattable)
library(dplyr)
library(shinydashboard)


tab3 <-tabPanel("College Comparison",
               fluidRow( selectInput('university', '', data$College, multiple=TRUE)),
               fluidRow(
  
                        wellPanel( column(3,dataTableOutput("universities.table")
                                          ))),
                fluidRow(
                  wellPanel(style = "overflow-y:scroll; height: 550px; opacity: 0.9; background-color: #ffffff;",
                            parcoordsOutput('par',width = '1200px',height='500px'))),
                 fluidRow( wellPanel(style = "overflow-y:scroll;  height: 500px; opacity: 0.9; background-color: #ffffff;",
                                                column(width = 9, plotOutput("tuitionPlot")
                                                ))),
                 fluidRow( wellPanel(style = "overflow-y:scroll;  height: 500px; opacity: 0.9; background-color: #ffffff;",
                                     column(width = 9, plotOutput("proportionPlot")
                                     )))
                           )
                                  


