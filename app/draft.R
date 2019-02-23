## Filtering 

location <- reactive({
  location <- input$location
})
major <- reactive({
  major <- input$major
})
highest_degree <- reactive({
  highest_degree <- input$highest_degree
})

control <- reactive({
  control <- input$control
})

x = reactive({
  x = if (location() == "") {
    x = x() }
  else{
    x = filter(x(), data$Location == location())
  }
}) 

x = reactive({
  x = if (input$location() == data$Location) {
    x = filter(x(), data$Location == location())}
  else{
    x = x()
  }
})

## Third map

#Helper function

showZipcodePopup = function(ID, lat, lng){
  lidata = lidata[lidata$UNITID == ID]
  content = as.character(tagList(tag$h4("University:", lidata$INSTNM),
                                 tags$strong(HTML(sprintf("information"))),
                                 tags$br(),
                                 sprintf("Rank:%s", lidata$Ranking),
                                 tags$br(),
                                 sprintf("Url:%s", lidata$INSTURL)
  ))
  leafletProxy("map_2") %>% addPopups(lat, lng, content, layerId = ID)
}

observe({
  
  data$Ranking = as.numeric(dat$Ranking)
  lirank = as.numeric(input$lirank)
  lidata = filter(data, Ranking < lirank)
  
  map_2 <- leaflet(data = lidata) %>%
    addTiles(
      urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
      attribution = 'Maps by <a href="http://www.mapbox.com/"Mapbox</a>') %>% 
    setView( lng = -93.85, lat = 37.45, zoom = 4) %>%
    clearShapes() %>%
    addCircles(~LONGITUDE, ~LATITUDE, radius = radius, layerId = ~UNITID, stroke = F, fillOpacity = opacity, fillColor = usedcolor)
  
  output$map_2 <- renderLeaflet(map_2)
  
  leafletProxy(map_2) %>% clearPopups()
  event = input$map_shape_click
  if (is.null(event))
    return()
  
  isolate({showZipcodePopup(event$id, event$lat, event$lng)})
}) 




#####
url = paste0(as.character("<b><a> href = 'http://"),
             as.character(filter4()$INSTURL),
             "'>",
             as.character(filter4()$INSTNM),
             as.character("<a><b>"))
content = paste(sep = "<br/>",
                url,
                paste("Rank:", as.character(filter4()$Ranking)))

#popup = content,

###
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
            "Business, Management, Marketing, and Related Support Services","History"))