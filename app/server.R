#setwd('~/Documents/GitHub/Spring2019-Proj2-grp4/app')
data_2 = read.csv("../output/processed_data_map_2.csv")
data = read.csv("../output/processed_data_map_1.csv")
data_v = read.csv("../output/processed_data_value_box.csv")

function(input, output) {
  
#Filters
  major <- reactive({
    major <- input$major
  })
  
  location <- reactive({
    location <- input$location
  })
  
  region <- reactive({
    region <- input$region
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
  
  filter1_2 = reactive({ 
   if(region() == "All") {filter1_2 = filter1() } else { filter1_2 = filter(filter1(), region() == REGION)}
  })
  
  filter2 = reactive({ 
    if(highest_degree() == "All") {filter2 = filter1_2() } else { filter2 = filter(filter1_2(), highest_degree() == HIGHDEG)}
  })
  
  filter3 = reactive({ 
    if(control() == "All") {filter3 = filter2() } else { filter3 = filter(filter2(), control() == CONTROL)}
  })
  
  filter4 = reactive({ 
    if(input$open_adm) {
      filter4 = filter(filter3(), OPENADMP == "Yes")
    } else { filter4 = filter3()}
  })
  
  output$or = renderText({ "___________ or___________"})
  ##Map 1
  
  #pal = colorFactor(palette = c("red", "blue", "green"), 
   #                 levels = c("Public", "PNP", "PFP"))  
  #map_0 <- leaflet() %>%
  # addTiles() %>%
  #  setView( lng = -93.85, lat = 37.45, zoom = 4) %>%
  # addCircleMarkers(lng = data$LONGITUDE,
  #                  lat = data$LATITUDE, popup = paste(data$INSTNM, "<br>", data$INSTURL), radius = 3, clusterOptions = markerClusterOptions()) 
  # setView( lng = -93.85, lat = 37.45, zoom = 4) %>%
  #  addResetMapButton()
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
  
  #output$map_0 <- renderLeaflet({map_0})
  
  output$map_1 = renderLeaflet({
    
    pal = colorFactor(palette = c("magenta", "darkblue", "black"), 
                      levels = c("Public", "PNP", "PFP"))
    
    url = paste0(as.character("<b><a href = 'http://"), as.character(filter4()$INSTURL),"'>", 
                 as.character(filter4()$INSTNM), as.character("</a></b>"))
    content = paste(sep = "<br/>",
                    url,
                    paste("Admission Rate:", as.character(filter4()$ADM_RATE)),
                    paste("Average ACT:", as.character(filter4()$ACTCMMID)),
                    paste("Average SAT:", as.character(filter4()$SAT_AVG)),
                    paste("Tuition (In-State):", as.character(filter4()$TUITIONFEE_IN)),
                    paste("Tuition (Out-Of-State):", as.character(filter4()$TUITIONFEE_OUT)))

    leaflet(data = filter4()) %>%
      addTiles() %>%
      addCircleMarkers(lng = filter4()$LONGITUDE,
                       lat = filter4()$LATITUDE, popup = content, radius = 3, color = ~pal(as.factor(filter4()$CONTROL)), clusterOptions = markerClusterOptions()) %>%
      addLegend(position = "bottomright", pal = pal, values = c("Public", "PNP", "PFP"), title = "University Type",
                labFormat = labelFormat(transform = function(values)  {
  values = replace(values, values=="PNP", "Private Non-Profit")
  values = replace(values, values=="PFP", "Private For Profit")
  return(values)
  })) 
    
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
   table = subset(filter4(), select = c("Ranking", "INSTNM", "ADM_RATE", "ACTCMMID", "SAT_AVG", "TUITIONFEE_IN", "TUITIONFEE_OUT"))
   
   colnames(table) = c("Rank", "Name", "Admission Rate", "Average ACT", "Average SAT", "Tuition (In-State)", "Tuition (Out-of-State)")
   
   datatable(table, rownames = F, selection = "single", options = list(order = list(list(0, "asc"), list(1, "asc")))) %>%
     formatPercentage(c("Admission Rate"), digits = 0) %>%
     formatCurrency(c("Tuition (In-State)"), digits = 0) %>%
     formatCurrency(c("Tuition (Out-of-State)"), digits = 0)
     
 }) 

}




