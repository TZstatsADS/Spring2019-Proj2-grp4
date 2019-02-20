load("./output/processed_data_map.rds")
function(input, output) {
  
  map_1 <- leaflet() %>%
    addTiles() %>%
    setView(lng = 360 - 95,
            lat = 40,
            zoom = 4) 
  output$map_1 <- renderLeaflet(map_1)
  
  # u.list <- reactive({if (input$add == 0) return() isolate({
  #   list(input$add, unlist(u.list()))
  # })})
  # 
  # output
  
}


