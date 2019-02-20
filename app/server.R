
function(input, output) {
  
  map_1 <- leaflet() %>%
    addTiles() %>%
    setView(lng = 360 - 95,
            lat = 40,
            zoom = 4) 
  output$map_1 <- renderLeaflet(map_1)
  
}


