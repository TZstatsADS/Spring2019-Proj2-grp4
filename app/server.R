#data = read.csv("processed_data_map.csv")
function(input, output) {
  
  map_1 <- leaflet() %>%
    addTiles() %>%
    setView(lng = 360 - 95,
            lat = 40,
            zoom = 4) %>%
    addMarkers(lng = data$LONGITUDE,
               lat = data$LATITUDE)
  output$map_1 <- renderLeaflet(map_1)
  
  # u.list <- reactive({if (input$add == 0) return() isolate({
  #   list(input$add, unlist(u.list()))
  # })})
  # 
  # output
  
  
  
}


