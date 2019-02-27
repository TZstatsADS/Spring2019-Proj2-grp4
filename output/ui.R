library(devtools)
library(plotly)
library(ggthemes)
library(shiny)
library(reshape2)
#library(parcoords)
library(stringr)
library(RColorBrewer)
#library(geosphere)
#library(formattable)
library(dplyr)
library(shinydashboard)
library(DT)
library(leaflet)

#Header

header <- dashboardHeader(title="University Hacker",
                          dropdownMenu(
                            type = "messages",
                            messageItem(
                              from = "University Hacker Team",
                              message = "Find YOUR university here!"
                            ),
                            messageItem(
                              from = "University Hacker Team",
                              message = "We use College Scorecard Data",
                              href = "https://collegescorecard.ed.gov/data/documentation/"
                            )
                          )
)

#Side Bar
majors = as.factor(c("All",
                     "Agriculture","Natural Resources and Conservation","Architecture",
                     "Cultural and Gender Studies","Communication and Journalism","Communications Technologies and Support Services",
                     "Computer and Information Sciences","Personal and Culinary Services","Education","Engineering","Engineering Technologies",
                     "Foreign Languages and Linguistics","Family and Consumer Sciences","Legal Professions and Studies","English Language and Literature",
                     "Liberal Arts and Sciences - General Studies and Humanities","Library Science","Biological and Biomedical Sciences","Mathematics and Statistics",
                     "Military Technologies and Applied Sciences","Interdisciplinary Studies","Recreation Studies","Philosophy and Religious Studies",
                     "Theology and Religious Vocations","Physical Sciences","Science Technologies","Psychology","Homeland Security, Law Enforcement, Firefighting and Related Protective Services",
                     "Public Administration","Social Sciences","Construction Trades","Mechanic and Repair Technologies","Precision Production",
                     "Transportation and Materials Moving","Visual and Performing Arts","Health Professions",
                     "Business Management and Marketing","History", "Other"))
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("GET STARTED",tabName="welcome",icon=icon("lightbulb-o")),
    menuItem("STEP 0: FILTER",tabName="filter",icon=icon("arrow-alt-circle-right"),
             selectInput("major", "Major",
                         choices = majors),
             selectInput("location","Location",
                         choices = c("All","Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado",
                                     "Connecticut", "Delaware", "District of Columbia", "Florida", "Georgia",
                                     "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky",
                                     "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota",
                                     "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire",
                                     "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", 
                                     "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", 
                                     "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", 
                                     "West Virginia", "Wisconsin", "Wyoming", "American Samoa", "Federated States of Micronesia", 
                                     "Guam", "Northern Mariana Islands", "Palau", "Puerto Rico", "Virgin Islands")),
             selectInput("highest_degree", "Degree", choices = c("All","Graduate","Bachelor","Associate","Certificate","Non-degree-granting")),
             selectInput("control", "Type", choices = c("All", "Public","Private nonprofit","Private for-profit")),
             checkboxInput("open_adm", "Open Admissions Policy")),
    menuItem("STEP 1: Browse",tabName="browse",icon=icon("arrow-alt-circle-right")),
    menuItem("STEP 2: Compare",tabName="compare",icon=icon("arrow-alt-circle-right")),
    menuItem("STEP 3: Dig In",tabName="dig_in",icon=icon("arrow-alt-circle-right"))
  )
)

livars = c("History" = "History", "Other" = "Other", "Psychology" = "Psychology")
#Body

body <- dashboardBody(
  tabItems(
    tabItem(tabName = "welcome",
            fluidRow(img(src = 'for-shiny-app-2.png'))),
    tabItem(tabName = "browse", ""),
    
    tabItem(tabName = "compare",""),
    tabItem(tabName="dig_in",
            fluidRow(
              tabBox(width = 12,
                     tabPanel(title = h3("Choose one university to find more :)"), solidHeader = T,
                              fluidRow(
                                column(4,
                                       selectizeInput('university','',
                                                      choices = c('',basic$INSTNM)))
                                )),
              
                  fluidRow(
                   
                    column(width = 8,offset = 4, h3(uiOutput("url"))),
                    column(width = 8,offset = 4,
                           h4(tableOutput("table")))
                    )),
              
              box(width = 12,title = strong("Academics"), solidHeader = F, collapsible = T,collapsed = TRUE,
                  fluidRow(
                    plotOutput("academics"))
                  ),
            
            box(width = 12,title = strong("Admission Rate"), solidHeader = F, collapsible = T,collapsed = TRUE,
                fluidRow(
                  plotOutput("adm_rate"))
                ),
              box(width = 12,title = strong("ACT Score"), solidHeader = F, collapsible = T,collapsed = TRUE,
                
                  tabBox(width = 12,
                      tabPanel("Cumulative", plotOutput("act_cul")),
                      tabPanel("English", plotOutput("act_en")),
                      tabPanel("Math", plotOutput("act_math"))
                    )
                    ),
              box(width = 12,title = strong("SAT Score"), solidHeader = F, collapsible = T,collapsed = TRUE,
                 
               tabBox(width = 12,
                      tabPanel('SAT equivalent score',width = 12, plotOutput('sat_eq')),
                      tabPanel("Critical Reading", widh = 12, plotOutput("sat_cr")),
                      tabPanel("Math",width = 12, plotOutput("sat_math"))
                    )
                    ),
              box(width = 12,title = strong("Tuition & Fee"), solidHeader = F, collapsible = T,collapsed = TRUE,
                 
                  tabBox(width = 12,
                      tabPanel('In-state',plotOutput('in_fee')),
                      tabPanel("Out-of-state", plotOutput("out_fee"))
                    ))

                 
              )) ))
  



#Get the dashboard

dashboardPage(skin = "green", header, sidebar, body)







# Define UI for application that draws a histogram
#shinyUI(fluidPage(
  # Application title
 # titlePanel("University Insight"),
  
  #fluidRow(
   # column(width = 4,
    #       selectizeInput('university','',
     #                     choices = basic$INSTNM)),
#    column(width = 8,offset = 4, uiOutput("url")),
 #   column(width = 8,offset = 4,
  #         tableOutput("table"))
#  ),
  
 # h3('Academics'),
#  fluidRow(
 #   plotOutput("academics")),
  
  #h3('Admission Rate'),
#  fluidRow(
 #   plotOutput("adm_rate")),
  
#  h3('ACT Scores'),
 # navlistPanel(
  #  tabPanel("Cumulative", plotOutput("act_cul")),
   # tabPanel("English", plotOutput("act_en")),

#    tabPanel("Math", plotOutput("act_math"))
 # ),
  
#  h3('SAT Scores'),
 # navlistPanel(
   # tabPanel('SAT equivalent score',plotOutput('sat_eq')),
  #  tabPanel("Critical Reading", plotOutput("sat_cr")),
 #   tabPanel("Math", plotOutput("sat_math"))
#  ),
  
 # h3('Tuition and Fee'),
#  navlistPanel(
    #tabPanel('In-state',plotOutput('in_fee')),
   # tabPanel("Out-of-state", plotOutput("out_fee"))
  #)
 
 # )
#)
