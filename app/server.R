data = read.csv("../output/processed_data_map.csv")
data_v = read.csv("../output/processed_data_value_box.csv")

#setwd('~/Documents/GitHub/Spring2019-Proj2-grp4')


function(input, output) {

 # my_icon = icon("map-pin", class = "fas fa-map-pin")
    
  map_1 <- leaflet() %>%
    addTiles() %>%
    addMarkers(lng = data$LONGITUDE,
               lat = data$LATITUDE, popup = data$INSTNM, clusterOptions = markerClusterOptions())
#    addLegend(labels = data$CONTROL, colors = c("blue", "red", "green"))
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
  names(data_v)
# output$rank <- renderValueBox({
# valueBox(value = top_rank, width = 4, subtitle = "Top Ranking", icon = icon("trophy", "fa-0.2x"), color = "maroon")
#})  
 output$rank <- renderTable(top_rank, colnames = FALSE) 
 
 top_afford = data_v %>%
   select(INSTNM, TUITIONFEE_IN) %>%
   filter(!is.na(TUITIONFEE_IN)) %>%
   arrange(TUITIONFEE_IN) %>%
   head(5)

 # output$rank <- renderValueBox({
 # valueBox(value = top_rank, width = 4, subtitle = "Top Ranking", icon = icon("trophy", "fa-0.2x"), color = "maroon")
 #})  
 output$afford <- renderTable(top_afford, colnames = FALSE) 
 
 
 

}


