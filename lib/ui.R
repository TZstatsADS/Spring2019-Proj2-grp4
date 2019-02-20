library(devtools)
library(shiny)
library(plotly)
library(parcoords)
library(stringr)
library(RColorBrewer)
tab3 <-tabPanel("College Comparison",
                fluidRow(
                  column(4,selectInput('university1', 'University1',data_compare_parcoord$College,selected =htmlOutput(''))),
                  column(4,selectInput('university2', 'University2',data_compare_parcoord$College,selected =htmlOutput(''))),
                  column(4,selectInput('university3', 'University3',data_compare_parcoord$College,selected =htmlOutput('')))),
                fluidRow(
                  wellPanel(style = "overflow-y:scroll; height: 550px; opacity: 0.9; background-color: #ffffff;",
                            parcoordsOutput('par',width = '1200px',height='500px')),
                 fluidRow( wellPanel(style = "overflow-y:scroll;  height: 500px; opacity: 0.9; background-color: #ffffff;",
                                                column(width = 9, plotOutput("carrierPlot")
                                                ))
  )))
                                  


