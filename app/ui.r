

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

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("GET STARTED",tabName="welcome",icon=icon("lightbulb-o")),
    menuItem("STEP 1: Browse",tabName="browse",icon=icon("arrow-alt-circle-right")),
    selectInput("location","Location",
                choices = c("All","AK","AL","AR","AS","AZ","CA","CO","CT","DC","DE"
                            ,"FL","FM","GA","GU","HI","IA","ID","IL","IN","KS","KY","LA","MA","MD"
                            ,"ME","MH","MI","MN","MO","MP","MS","MT","NC","ND","NE","NH","NJ","NM","NV"
                            ,"NY","OH","OK","OR"
                            ,"PA","PR","PW","RI","SC","SD","TN","TX","UT","VA","VI","VT"
                            ,"WA","WI","WV","WY")),
    selectInput("major", "Major",
                choices = c("All",
                            "Agriculture, Agriculture Operations, and Related Sciences","Natural Resources and Conservation","Architecture and Related Services",
                            "Area, Ethnic, Cultural, Gender, and Group Studies","Communication, Journalism, and Related Programs","Communications Technologies/Technicians and Support Services",
                            "Computer and Information Sciences and Support Services","Personal and Culinary Services","Education","Engineering","Engineering Technologies and Engineering-Related Fields",
                            "Foreign Languages, Literatures, and Linguistics","Family and Consumer Sciences/Human Sciences","Legal Professions and Studies","English Language and Literature/Letters",
                            "Liberal Arts and Sciences, General Studies and Humanities","Library Science","Biological and Biomedical Sciences","Mathematics and Statistics",
                            "Military Technologies and Applied Sciences","Multi/Interdisciplinary Studies","Parks, Recreation, Leisure, and Fitness Studies","Philosophy and Religious Studies",
                            "Theology and Religious Vocations","Physical Sciences","Science Technologies/Technicians","Psychology","Homeland Security, Law Enforcement, Firefighting and Related Protective Services",
                            "Public Administration and Social Service Professions","Social Sciences","Construction Trades","Mechanic and Repair Technologies/Technicians","Precision Production",
                            "Transportation and Materials Moving","Visual and Performing Arts","Health Professions and Related Programs",
                            "Business, Management, Marketing, and Related Support Services","History")),
    selectInput("highest_degree", "Degree", choices = c("All","Graduate","Bachelor","Associate","Certificate","Non-degree-granting")),
    checkboxGroupInput("control", "Type", choices = c("Public","Private nonprofit","Private for-profit")),
    menuItem("STEP 2: Compare",tabName="compare",icon=icon("arrow-alt-circle-right")),
    menuItem("STEP 3: Dig In",tabName="dig_in",icon=icon("arrow-alt-circle-right"))
  )
)

#Body

body <- dashboardBody(
  tabItems(
    tabItem(tabName = "welcome",
            fluidPage(img(src = 'for-shiny-app-2.png'))),
    tabItem(tabName = "browse",
            fluidRow(
              valueBox(width = 4, value = "TBD", subtitle = "Top Ranking", icon = icon("trophy", "fa-0.5x"), color = "maroon"),
              valueBox(width = 4, value = "TBD", subtitle = "Most Affordable", icon = icon("dollar-sign", "fa-0.5x"), color = "aqua"),
              valueBox(width = 4, value = "TBD", subtitle = "Highest Admission", icon = icon("shield-check", "fa-0.5x"), color = "orange"),
              tabBox(width = 12, 
                     tabPanel(title="Map", width = 12, solidHeader = T, leafletOutput("map_1")))
            ),
                     tabPanel("This is a placeholder for TABLE/buttons")
            ),
           #           tabPanel(actionButton("add", "Add University")
           #                    
           #  ),
           # 
           #            tabPanel(verbartimTextOutput("list")
           #   
           # ),
    
    
    tabItem(tabName="compare", "Placeholder - Step 2: Compare Universities of Choice"),
    
    tabItem(tabName="dig_in", "Placeholder - Step 3: Dig into Details on THE University")
    
  )
)

#Get the dashboard

dashboardPage(skin = "green", header, sidebar, body)
