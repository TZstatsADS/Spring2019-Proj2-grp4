#setwd('~/Documents/GitHub/Spring2019-Proj2-grp4/app')
data_2 = read.csv("../output/processed_data_map_2.csv")
data = read.csv("../output/processed_data_map_1.csv")
data_v = read.csv("../output/processed_data_value_box.csv")

function(input, output) {
    
  map_1 <- leaflet() %>%
    addTiles() %>%
    addCircleMarkers(lng = data$LONGITUDE,
               lat = data$LATITUDE, popup = paste(data$INSTNM, "<br>", data$INSTURL), clusterOptions = markerClusterOptions()) #%>%
#    addLegend(values = ~data$CONTROL, colors = c("green", "blue", "red"))

  output$map_1 <- renderLeaflet(map_1)
  
#Filters
  major <- reactive({
    major <- input$major
  })
  
  location <- reactive({
    location <- input$location
  })
  
  highest_degree <- reactive({
    highest_degree <- input$highest_degree
  })
  
  control <- reactive({
    control <- input$control
  })
  
  open_adm <- reactive({ 
    open_adm <- input$open_adm
  })
  
  
  filter_start = reactive({ filter_start = data })
  
  filter0 = reactive({
    if(major() == "All") {filter0  = filter_start() } else { filter0 = filter_start()[filter_start()[, major()] == 1, ]}
  })
  
  filter1 = reactive({ 
   if(location() == "All") {filter1 = filter0() } else { filter1 = filter(filter0(), location() == Location)}
  })
  
  filter2 = reactive({ 
    if(highest_degree() == "All") {filter2 = filter1() } else { filter2 = filter(filter1(), highest_degree() == HIGHDEG)}
  })
  
  filter3 = reactive({ 
    if(control() == "All") {filter3 = filter2() } else { filter3 = filter(filter2(), control() == CONTROL)}
  })
  
  filter4 = reactive({ 
    if(input$open_adm) {
      filter4 = filter(filter3(), OPENADMP == "Yes")
    } else { filter4 = filter3()}
  })
  
  output$map_1 = renderLeaflet({
    url = paste0(as.character("<b><a href = 'http://"), as.character(filter4()$INSTURL),"'>", 
                 as.character(filter4()$INSTNM), as.character("</a></b>"))
    content = paste(sep = "<br/>",
                    url,
                    paste("Rank:", as.character(filter4()$Ranking)))
                 
    mapStates = map("state", fill = TRUE, plot = FALSE)
    
    leaflet(data = mapStates) %>%
      addTiles() %>%
      addCircleMarkers(lng = filter4()$LONGITUDE,
                       lat = filter4()$LATITUDE, popup = content, clusterOptions = markerClusterOptions())
  })
 
##Second map

 observe({
   
   usedcolor <- "green"
   
   data_2$Ranking = as.numeric(data_2$Ranking)
   lirank = as.numeric(input$lirank)
   lidata = filter(data_2, Ranking < lirank)
   radius = lidata$History*1000000
   opacity = 0.8
   
   if(input$color == "Other") {
     usedcolor = "yellow"
     radius = lidata$Other*1000000
     opacity = 0.8
   } else if(input$color == "Psychology") {
     usedcolor = "red"
     radius = lidata$Psychology*1000000
     opacity = 0.8
     }
 
 map_2 <- leaflet(data = lidata) %>%
   addTiles(
     urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
     attribution = 'Maps by <a href="http://www.mapbox.com/"Mapbox</a>') %>% 
   setView( lng = -93.85, lat = 37.45, zoom = 4) %>%
   clearShapes() %>%
   addCircles(~LONGITUDE, ~LATITUDE, radius = radius, layerId = ~UNITID, stroke = F, fillOpacity = opacity, fillColor = usedcolor)
 
 output$map_2 <- renderLeaflet(map_2)
})  



## Info boxes
#  top_rank = data_v %>%
#    select(INSTNM, Ranking) %>%
#    filter(!is.na(Ranking)) %>%
 #   arrange(Ranking) %>%
 #   head(3)
 
 
#library(DT)
#  output$rank <- renderDataTable({
    
#    table_1 = subset(filter4(), select(c("INSTNM", "Ranking")))
#    colnames(table_1) = c("University", "Rank")
#    table_1 = head(table_1, 5)
    
   #datatable(table_1, rownames = F, selection = "single", option = list(order = list(0, "asc"), list(1, "asc")))
    
#  }) 
 
 #top_afford = data_v %>%
#   select(INSTNM, TUITIONFEE_IN) %>%
#   filter(!is.na(TUITIONFEE_IN)) %>%
 #  arrange(TUITIONFEE_IN) %>%
 #  head(3)

 #output$afford <- renderTable(top_afford, colnames = F) 
 
 ## Info boxes
 top_rank = data_v %>%
   select(INSTNM, Ranking) %>%
   filter(!is.na(Ranking)) %>%
   arrange(Ranking) %>%
   head(3)
 
 output$rank <- renderTable(top_rank, colnames = F) 
 
 top_afford = data_v %>%
   select(INSTNM, TUITIONFEE_IN) %>%
   filter(!is.na(TUITIONFEE_IN)) %>%
   arrange(TUITIONFEE_IN) %>%
   head(3)
 
 output$afford <- renderTable(top_afford, colnames = F) 
 

}




