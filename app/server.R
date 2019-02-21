#setwd('~/Documents/GitHub/Spring2019-Proj2-grp4/app')
data = read.csv("../output/processed_data_map.csv")
data_v = read.csv("../output/processed_data_value_box.csv")

function(input, output) {
    
  map_1 <- leaflet() %>%
    addTiles() %>%
    addMarkers(lng = data$LONGITUDE,
               lat = data$LATITUDE, popup = data$INSTNM, clusterOptions = markerClusterOptions())

  output$map_1 <- renderLeaflet(map_1)
 
#filtering 
  # 
  # location <- reactive({
  #   location <- input$location
  # })
  # major <- reactive({
  #   major <- input$major
  # })
  # 
## Info boxes
  top_rank = data_v %>%
    select(INSTNM, Ranking) %>%
    filter(!is.na(Ranking)) %>%
    arrange(Ranking) %>%
    head(5)

  output$rank <- renderTable(top_rank, colnames = F) 
 
 top_afford = data_v %>%
   select(INSTNM, TUITIONFEE_IN) %>%
   filter(!is.na(TUITIONFEE_IN)) %>%
   arrange(TUITIONFEE_IN) %>%
   head(5)

 output$afford <- renderTable(top_afford, colnames = F) 

 }


