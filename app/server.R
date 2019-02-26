#setwd('~/Documents/GitHub/Spring2019-Proj2-grp4/app')
data_2 = read.csv("../output/processed_data_map_2.csv")
data = read.csv("../output/processed_data_map_1.csv")
data_v = read.csv("../output/processed_data_value_box.csv")

function(input, output) {
  #pal = colorFactor(palette = c("red", "blue", "green"), 
  #                  levels = c("Public", "PNP", "PFP"))  
  map_1 <- leaflet() %>%
    addTiles(
      urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
      attribution = 'Maps by <a href="http://www.mapbox.com/"Mapbox</a>') %>%
    addCircleMarkers(lng = data$LONGITUDE,
                     lat = data$LATITUDE, popup = paste(data$INSTNM, "<br>", data$INSTURL), radius = 3, clusterOptions = markerClusterOptions()) 
    #setView( lng = -93.85, lat = 37.45, zoom = 4) %>%
    #fitBounds(lng1 = -124.7844079, lng2 = -669513812,
    #          lat1 = 49.3457868, lat2 = 24.7433195) %>%
    #setMaxBounds(lng1 = -124.7844079, lng2 = -669513812,
    #          lat1 = 49.3457868, lat2 = 24.7433195) %>%
    
    #clearShapes() %>%
    #addSearchOSM()
    #addResetMapButton()
    #addLegend(position = "bottomright", pal = pal, values = c("Public", "PNP", "PFP")) #color = ~pal(as.factor(data$CONTROL))
    #setView( lng = -93.85, lat = 37.45, zoom = 4)
  #label = ~data$INSTNM
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
     radius = lidata$Other*100000
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
 
#### Value Boxes
 
 output$avgBox_in <- renderValueBox({
   currency.sym = "$"
   avg_in = filter(filter4(), TUITIONFEE_IN!="NULL" & !is.na(TUITIONFEE_IN))
   avg_in = round(mean(as.numeric(as.character(avg_in$TUITIONFEE_IN))), digits = 0)
   avg_in_comma = comma(avg_in)
  
   if (!is.nan(avg_in)) {
     valueBox(value = paste(currency.sym, avg_in_comma), subtitle = "Avg Tuition In-State", icon = icon("dollar-sign"), color = "orange") 
   } else {
     valueBox(value = "No Offers", subtitle = "Avg Tuition In-State", icon = icon("dollar-sign"), color = "orange")
   }
   
   })
 
 output$avgBox_out <- renderValueBox({
   currency.sym = "$"
   avg_out = filter(filter4(), TUITIONFEE_OUT!="NULL" & !is.na(TUITIONFEE_OUT))
   avg_out = round(mean(as.numeric(as.character(avg_out$TUITIONFEE_OUT))), digits = 0)
   avg_out_comma = comma(avg_out)
   
   if (!is.nan(avg_out)) {
     valueBox(value = paste(currency.sym, avg_out_comma), subtitle = "Avg Tuition OOF-State", icon = icon("dollar-sign"))
   } else {
     valueBox(value = "No Offers", subtitle = "Avg Tuition OOF-State", icon = icon("dollar-sign"))
   }
 
 })

 output$avgBox_act <- renderValueBox({
   act = filter(filter4(), ACTCMMID !="NULL" & !is.na(ACTCMMID))
   act = round(mean(as.numeric(as.character(act$ACTCMMID))), digits = 0)
   if (!is.nan(act)) {
     valueBox(value = act, subtitle = "Avg ACT", icon = icon("star"), color = "olive")
   } else {
     valueBox(value = "Any", subtitle = "Avg ACT", icon = icon("star"), color = "olive")
   }
   
 }) 
 
 output$avgBox_sat <- renderValueBox({
   sat = filter(filter4(), SAT_AVG !="NULL" & !is.na(SAT_AVG))
   sat = round(mean(as.numeric(as.character(sat$SAT_AVG))), digits = 0)
   
   if (!is.nan(sat)) {
     valueBox(value = sat, subtitle = "Avg SAT", icon = icon("star"), color = "olive")
   } else {
     valueBox(value = "Any", subtitle = "Avg SAT", icon = icon("star"), color = "olive")
   }
 })
 
 output$avgBox_adm <- renderValueBox({
   currency.perc = "%"
   avg_adm = filter(filter4(), ADM_RATE!="NULL" & !is.na(ADM_RATE))
   avg_adm = round(mean(as.numeric(as.character(avg_adm$ADM_RATE))), digits = 2)
   if (!is.nan(avg_adm)) {
     valueBox(value = avg_adm, subtitle = "Avg Admission", icon = icon("sign-in-alt"), color = "maroon")
   } else {
     valueBox(value = "Any", subtitle = "Avg Admission", icon = icon("sign-in-alt"), color = "maroon")
   }
}) 
 
 ##Table
 
 output$uni_table = DT::renderDataTable({
   table = subset(filter4(), select = c("Ranking", "INSTNM", "ADM_RATE", "CONTROL", "INSTURL", "ACTCMMID", "SAT_AVG", "OPENADMP", "TUITIONFEE_IN", "TUITIONFEE_OUT"))
   
   colnames(table) = c("Rank", "Name", "Admission Rate", "Type", "URL", "Average ACT","Average SAT", "Open Admission Policy", "Tuition (In-State)", "Tuition (Out-of-State)")
   
   datatable(table, rownames = F, selection = "single", options = list(order = list(list(0, "asc"), list(1, "asc")))) %>%
     formatPercentage(c("Admission Rate"), digits = 0) %>%
     formatCurrency(c("Tuition (In-State)"), digits = 0) %>%
     formatCurrency(c("Tuition (Out-of-State)"), digits = 0)
     
 }) 

}




