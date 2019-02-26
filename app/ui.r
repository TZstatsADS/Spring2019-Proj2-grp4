
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

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("GET STARTED",tabName="welcome",icon=icon("lightbulb-o")),
    menuItem("STEP 1: Browse",tabName="browse",icon=icon("arrow-alt-circle-right")),
    menuItem("       Use Filter",tabName="filter",icon=icon("filter"),
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
    tabItem(tabName = "filter"
      
    ),
    tabItem(tabName = "browse",
            fluidRow(
              valueBoxOutput(width = 3, "avgBox_in"),
              valueBoxOutput(width = 3, "avgBox_out"),
              valueBoxOutput(width = 2, "avgBox_act"),
              valueBoxOutput(width = 2, "avgBox_sat"),
              valueBoxOutput(width = 2, "avgBox_adm"),
              tabBox(width = 12, 
                     tabPanel(title="Map", width = 12, solidHeader = T, leafletOutput("map_1")),
                     tabPanel(title="Map_2", width = 12, solidHeader = T, 
                              leafletOutput("map_2"),
                              absolutePanel(id = "controls", class = "panel panel-default", fixed = T, draggable = T, top = "auto", left = "auto", 
                                            right = 60, bottom = 20, width = "300", hight = "auto",
                                            h5("Major Hacker"), 
                                            
                                            sliderInput("lirank", "Rank", min = 1, max = 300, value = 300),
                                            selectInput("color", "Major", livars)))),
              tabBox(width = 12,
                     tabPanel('Detail',
                              dataTableOutput("uni_table"),
                              tags$style((type = "text/css")))))),
    
    tabItem(tabName="compare", "Placeholder - Step 2: Compare Universities of Choice"),
    tabItem(tabName="dig_in", "Placeholder - Step 3: Dig into Details on THE University")
  )
)
)

#Get the dashboard

dashboardPage(skin = "green", header, sidebar, body)
