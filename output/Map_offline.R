data = read.csv("processed_data_map.csv")
summary(data)
US_uni <- sum(ifelse(
  data$LATITUDE <64.9 & data$LATITUDE > 19.5 & data$LONGITUDE < -68.0 & data$LONGITUDE > -161.8, 1, 0
  
), na.rm = T)

map_1 <- leaflet() %>%
  addTiles() %>%
  # setView(lng = 360 - 95,
  #         lat = 40,
  #         zoom = 4) %>%
  addCircleMarkers(lng = data$LONGITUDE,
             lat = data$LATITUDE, color = as.factor(data$CONTROL)) %>%
  addLegend(labels = c("P", "NP", "FP"), colors = c("blue", "red", "green"))
typeof(data$CONTROL)