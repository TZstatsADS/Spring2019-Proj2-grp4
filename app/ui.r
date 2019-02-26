
#Header

header <- dashboardHeader(title="University Hacker",
                          dropdownMenu(
                            type = "messages",
                            messageItem(
                              from = "University Hacker Team",
                              message = "We use College Scorecard Data",
                              href = "https://collegescorecard.ed.gov/data/documentation/"
                            )
                            )
                          )
  
#Side Bar
majors = c("All" = "All",
           "Agriculture" = "Agriculture",
           "Natural Resources and Conservation" = "Natural",
           "Architecture" = "Architecture",
           "Cultural and Gender Studies" = "Cultural_Gender",
           "Communication and Journalism" = "Journalism",
           "Communications Technologies and Support Services" = "Communications_Technologies",
           "Computer and Information Sciences" = "Computer",
           "Personal and Culinary Services" = "Personal_Culinary",
           "Education" = "Education",
           "Engineering" = "Engineering",
           "Engineering Technologies" = "Engineering_Technologies",
           "Foreign Languages and Linguistics" = "Foreign_Languages",
           "Family and Consumer Sciences" = "Family_Consumer",
           "Legal Professions and Studies" = "Legal",
           "English Language and Literature" = "English",
           "Liberal Arts and Sciences - General Studies and Humanities" = "Liberal_Arts_Sciences",
           "Library Science" = "Library",
           "Biological and Biomedical Sciences" = "Biological_Biomedical",
           "Mathematics and Statistics" = "Math_Stat",
           "Military Technologies and Applied Sciences" = "Military",
           "Interdisciplinary Studies" = "Interdisciplinary",
           "Recreation Studies" = "Recreation",
           "Philosophy and Religious Studies" = "Philosophy_Religious",
           "Theology and Religious Vocations" = "Theology",
           "Physical Sciences" = "Physical",
           "Science Technologies" = "Science_Tech",
           "Psychology" = "Psychology",
           "Homeland Security, Law Enforcement, Firefighting and Related Protective Services" = "Homeland_Security",
           "Public Administration" = "Public",
           "Social Sciences" = "Social",
           "Construction Trades" = "Construction",
           "Mechanic and Repair Technologies" = "Mechanic",
           "Precision Production" = "Precision",
           "Transportation and Materials Moving" = "Transportation",
           "Visual and Performing Arts" = "Visual_Arts",
           "Health Professions" = "Health",
           "Business Management and Marketing" = "Business",
           "History" = "History", 
           "Other" = "Other")

control_var = c("All" = "All", 
                "Public" = "Public",
                "Private nonprofit" = "PNP",
                "Private for-profit" = "PFP")

regions = c("All", "U.S. Service Schools" = "Service", "New England" = "New_Eng", "Mid East" = "Mid_East","Great Lakes" = "Great_Lakes","Plains" = "Plains", "Southeast" = "Southeast", 
                                       "Southwest" = "Southwest","Rocky Mountains" = "Rocky_Mountains", "Far West" = "Far_West", "Outlying Areas" = "Outlying")
states = c("All","Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado",
                                     "Connecticut", "Delaware", "District of Columbia", "Florida", "Georgia",
                                     "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky",
                                     "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota",
                                     "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire",
                                     "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", 
                                     "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", 
                                     "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", 
                                     "West Virginia", "Wisconsin", "Wyoming", "American Samoa", "Federated States of Micronesia", 
                                     "Guam", "Northern Mariana Islands", "Palau", "Puerto Rico", "Virgin Islands")
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("GET STARTED",tabName="welcome",icon=icon("lightbulb-o")),
    menuItem("STEP 1: Browse",tabName="browse",icon=icon("arrow-alt-circle-right")),
    menuItem("       Use Filter",tabName="filter",icon=icon("filter"),
             selectInput("major", "Major", choices = majors),
             br(),
             selectInput("location","State", choices = states),
             h4(textOutput("or")),
             selectInput("region", "Region", choices = regions),
             br(),
             selectInput("highest_degree", "Highest Degree", choices = c("All","Graduate","Bachelor","Associate","Certificate","Non-degree-granting")),
             selectInput("control", "Type", choices = control_var),
             checkboxInput("open_adm", "Open Admissions Policy")),
    menuItem("STEP 2: Compare",tabName="compare",icon=icon("arrow-alt-circle-right")),
    menuItem("STEP 3: Dig In",tabName="dig_in",icon=icon("arrow-alt-circle-right"))
  )
)

livars = c("History" = "History", "Other" = "Other", "Psychology" = "Psychology")
#Body

body <- dashboardBody(
  fluidPage(
  tabItems(
    tabItem(tabName = "welcome",
            fluidRow(img(src = 'for-shiny-app-3.png'),
                     img(src = 'shiny_ad.png'))),
    tabItem(tabName = "filter"),
    tabItem(tabName = "browse",
            fluidRow(
              valueBoxOutput(width = 3, "avgBox_in"),
              valueBoxOutput(width = 3, "avgBox_out"),
              valueBoxOutput(width = 2, "avgBox_act"),
              valueBoxOutput(width = 2, "avgBox_sat"),
              valueBoxOutput(width = 2, "avgBox_adm"),
              tabBox(width = 12, 
                     tabPanel(title="Map", width = 12, solidHeader = T, leafletOutput("map_1"))),
              tabBox(width = 12,
                     tabPanel('Detail',
                              dataTableOutput("uni_table"),
                              tags$style((type = "text/css")))))),
    
    tabItem(tabName="compare",
            fluidRow(
              tabBox(width = 12,
                     tabPanel(title = h3("Select the universities that interest you :)"), solidHeader = T,
                              fluidRow(
                                column(12,selectInput('university', '', data_c$College, multiple=TRUE))))),
              box(width = 12,collapsible = T,
                  title = strong("Basic Information"), solidHeader = F,
                  fluidRow(
                    column(12, DT::dataTableOutput("universities.table")))),
              
              box(width = 12,title = strong("Visualization"), solidHeader = F, collapsible = T,collapsed = TRUE,
                  fluidRow(
                    column(12, h4("1.Parcoords Comparison")),
                    column(12, parcoordsOutput('par',width = '1200px',height='500px'))),
                  hr(),
                  fluidRow( 
                    column(12, h4("2.Tuition & Earnings Comparison (Unit: dollar)")),
                    hr(),
                    plotOutput("tuitionPlot")),
                  fluidRow( 
                    column(12, h4("3.Rates Comparison")),
                    hr(),
                    plotOutput("proportionPlot"),
                    p(em("Note: Value of 0 represents information unavailable")))
              ))
            
            
            ),
    tabItem(tabName="dig_in",
            fluidRow(
              tabBox(width = 12,
                     tabPanel(title = h3("Choose one university to find more :)"), solidHeader = T,
                              fluidRow(
                                column(4,
                                       selectizeInput('university1','',
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
            
            
            
            )
  ))))



#Get the dashboard

dashboardPage(skin = "green", header, sidebar, body)
