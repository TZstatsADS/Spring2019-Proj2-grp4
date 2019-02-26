setwd('~/Documents/GitHub/Spring2019-Proj2-grp4/app')
data_2 = read.csv("../output/processed_data_map_2.csv")
data = read.csv("../output/processed_data_map_1.csv")
data_v = read.csv("../output/processed_data_value_box.csv")
data_c = read.csv("../output/data_compare_3.csv",header = TRUE)
data_c$Unemployment.Rate <- data_c$Unemployment.Rate/100
basic = read.csv('../output/basic.csv', stringsAsFactors=FALSE)
academics = read.csv('../output/academics.csv', stringsAsFactors=FALSE)
act = read.csv('../output/act.csv', stringsAsFactors=FALSE)
sat = read.csv('../output/sat.csv', stringsAsFactors=FALSE) 
cost = read.csv('../output/cost.csv', stringsAsFactors=FALSE)
adm_rate = read.csv('../output/adm_rate.csv', stringsAsFactors=FALSE)

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
                    paste("Tuition (In-State): $", as.character(filter4()$TUITIONFEE_IN)),
                    paste("Tuition (Out-Of-State): $", as.character(filter4()$TUITIONFEE_OUT)))

    leaflet(data = filter4()) %>%
      addTiles() %>%
      addCircleMarkers(lng = filter4()$LONGITUDE,
                       lat = filter4()$LATITUDE, popup = content, radius = 4, color = ~pal(as.factor(filter4()$CONTROL)), clusterOptions = markerClusterOptions()) %>%
      addLegend(position = "topright", pal = pal, values = c("Public", "PNP", "PFP"), title = "University Type",
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

 
 
 # basic information table
 output$universities.table = DT::renderDataTable({
   s=input$university
   if(length(s)){
     data_list<- data_c %>% dplyr::select(College,Rank,City,State,Region,
                                          City.size,Control,Highest.Degree) %>% 
       filter (College %in% input$university)
     colnames(data_list)[c(6,8)]=c("City Size","Highest Degree")
     data_list$Rank<-as.numeric(as.character(data_list$Rank))
     data_list
   }   
 },
 options=list(dom='tir',language=list(info='Note: Empty rank means rank over 230')))
 
 
 # Tuition & earnings compare
 output$tuitionPlot <- renderPlot({
   data_hist <- data_c %>% dplyr::select(1, Tuition.Fee.in.state,Tuition.Fee.out.state,
                                         Mean.Earnings.Female.Students,Mean.Earnings.Male.Students) %>% 
     filter (College %in% input$university)
   colnames(data_hist)[2:5]<-c("Tuition Fee in state","Tuition Fee out state",
                               "Mean Earnings Female Students","Mean Earnings Male Students")
   data_melt <- reshape2::melt(data_hist, id = "College")
   data_melt$value=as.numeric(data_melt$value)
   data_melt$value[is.na(data_melt$value)] <- 0
   data_melt$value[is.null(data_melt$value)] <- 0
   ggplot(data=data_melt, aes(x=variable,y=value,fill=College))+
     geom_bar(stat="identity", width=.5,position=position_dodge((.7)))+
     guides(fill=guide_legend(title=NULL))+
     labs(y="unit:dollar")+
     geom_text(aes(label = round(value,2)),position=position_dodge(width=0.7), vjust=-0.25)+
     theme_wsj()+
     theme(axis.title = element_blank(),legend.position = 'top')
   
 })
 
 # Proportion rate compare
 output$proportionPlot <- renderPlot({
   data_proportion <- data_c %>% dplyr::select(1,Female.Proportion,Married,
                                               Unemployment.Rate,Share.of.Students.Earning.over..25.000.year) %>% 
     filter (College %in% input$university)
   colnames(data_proportion)[2:5]<-c("Female Proportion","Married",
                                     "Unemployment Rate","Share of Students Earning over 25,000 per year")
   data_melt_proportion <- reshape2::melt(data_proportion, id = "College")
   data_melt_proportion$value=as.numeric(data_melt_proportion$value)
   data_melt_proportion$value[is.na(data_melt_proportion$value)] <- 0
   data_melt_proportion$value[is.null(data_melt_proportion$value)] <- 0
   ggplot(data=data_melt_proportion, aes(x=variable,y=value,fill=College))+
     geom_bar(stat="identity", width=.5,position=position_dodge((.7)))+
     guides(fill=guide_legend(title=NULL))+
     geom_text(aes(label = round(value,2)), position=position_dodge(width=0.7), vjust=-0.25)+
     theme(axis.title = element_blank(),legend.position = 'top')+ 
     scale_y_continuous(breaks=seq(0,1,0.1))+
     theme_wsj()
 })
 
 
 
 # parcoords graph
 output$par <- renderParcoords({
   data_Parcoords<-data_c %>% dplyr::select(1,Admission.Rate,ACT.score,
                                            SAT.score,Mean.Earnings.Students) %>% 
     filter(College %in% input$university)
   colnames(data_Parcoords)[2:5]=c("Admission Rate","ACT score",
                                   "SAT score","Mean Earnings of Students")
   # change data into numeric
   data_Parcoords[,2]<-as.numeric(as.character(data_Parcoords[,2]))
   data_Parcoords[,2][is.na(data_Parcoords[,2])]<-0
   data_Parcoords[,3]<-as.numeric(as.character(data_Parcoords[,3]))
   data_Parcoords[,3][is.na(data_Parcoords[,3])]<-0
   data_Parcoords[,4]<-as.numeric(as.character(data_Parcoords[,4]))
   data_Parcoords[,4][is.na(data_Parcoords[,4])]<-0
   data_Parcoords[,5]<-as.numeric(as.character(data_Parcoords[,5]))
   data_Parcoords[,5][is.na(data_Parcoords[,5])]<-0
   parcoords(data_Parcoords, rownames = F
             , brushMode = "1d-axes"
             , reorderable = T
             , queue = F
             , color = list(
               colorBy = "College"
               , colorScale = htmlwidgets::JS("d3.scale.category10()"))
   )
 }) 
 
 ###dig in part
 ## Basic Information 
 output$url <- renderUI({
   university <- basic[which(basic$INSTNM==input$university1),]
   url = a(university$INSTNM, 
           href = paste0("http://",tolower(university$INSTURL)))
 })
 
 output$table <- renderTable({
   university <- basic[which(basic$INSTNM==input$university1),]
   Items<-c("city", "Rank", "Admission rate",'Control of Institution', 
            'Highest Degree Awarded', 'Average family income')
   Value<-c(university$CITY, university$Ranking, as.numeric(university$ADM_RATE),
            university$CONTROL, university$HIGHDEG, as.numeric(university$FAMINC))
   data.frame(cbind(Items, Value))
 })
 
 ## Academics
 output$academics <- renderPlot({
   loc = which(academics$INSTNM==input$university1)
   if (length(loc)){
     major = as.numeric(unlist(academics[loc, 3:40]))
     major_name = colnames(academics)[3:40]
     major[is.na(major)] = 0
     if (sum(major) != 1)
       ggplot() + ggtitle("No information available")
     else{
       major = major[which(major!=0)]
       major_name=major_name[which(major!=0)]
       ggplot() +
         geom_bar(mapping = aes(x =' ', y = major, fill = major_name),stat = 'identity', position = 'stack') +
         coord_polar(theta = "y")}}
   else
     ggplot() + ggtitle("Select a university")
 })
 
 ## Admission Rate
 output$adm_rate <- renderPlot({
   loc = which(adm_rate$INSTNM==input$university1)
   if (length(loc)){
     adm_rate = data_frame(year = 2008:2017,
                           rate = as.numeric(unlist(adm_rate[loc, 4:13])))
     if (is.na(sum(adm_rate$rate50)))
       ggplot() + ggtitle("No information available")
     else
       ggplot(data = adm_rate) + 
       geom_point(aes(x = year, y = rate)) + 
       geom_smooth(aes(x = year, y = rate), method = lm) + 
       scale_x_continuous(breaks=adm_rate$year) + ylab("Admission Rate")+theme_wsj()}
   else
     ggplot() + ggtitle("Select a university")
 })
 
 ## Scores
 
 ### ACT
 output$act_cul <- renderPlot({
   loc = which(act$INSTNM==input$university1)
   if (length(loc)){
     cul = data_frame(year = 2008:2017,
                      cul50 = as.numeric(unlist(act[loc, seq(5,93,9)])),
                      cul25 = as.numeric(unlist(act[loc, seq(4,93,9)])),
                      cul75 = as.numeric(unlist(act[loc, seq(6,93,9)])))
     if (is.na(sum(cul$cul50)))
       ggplot() + ggtitle("No information available")
     else
       ggplot(data = cul) +
       geom_point(aes(x = year, y = cul50)) + 
       geom_smooth(aes(x = year, y = cul50), method = lm, color = "black") + 
       geom_line(aes(x = year, y = cul25), color = "red") +
       geom_line(aes(x = year, y = cul75), color = "red") +
       scale_x_continuous(breaks=cul$year) + ylab("cumulative score")+theme_wsj()}
   else
     ggplot() + ggtitle("Select a university")
 })
 
 output$act_en <- renderPlot({
   loc = which(act$INSTNM==input$university1)
   if (length(loc)){
     en = data_frame(year = 2008:2017,
                     en50 = as.numeric(unlist(act[loc, seq(8,93,9)])),
                     en25 = as.numeric(unlist(act[loc, seq(7,93,9)])),
                     en75 = as.numeric(unlist(act[loc, seq(9,93,9)])))
     if (is.na(sum(en$en50)))
       ggplot() + ggtitle("No information available")
     else
       ggplot(data = en) +
       geom_point(aes(x = year, y = en50)) + 
       geom_smooth(aes(x = year, y = en50), method = lm, color = "black") + 
       geom_line(aes(x = year, y = en25), color = "red") +
       geom_line(aes(x = year, y = en75), color = "red") +
       scale_x_continuous(breaks=en$year) + ylab("English score")+theme_wsj()}
   else
     ggplot() + ggtitle("Select a university")
 })
 
 output$act_math <- renderPlot({
   loc = which(act$INSTNM==input$university1)
   if (length(input$university1)){
     math = data_frame(year = 2008:2017,
                       math50 = as.numeric(unlist(act[loc, seq(11,93,9)])),
                       math25 = as.numeric(unlist(act[loc, seq(10,93,9)])),
                       math75 = as.numeric(unlist(act[loc, seq(12,93,9)])))
     if (is.na(sum(math$math50)))
       ggplot() + ggtitle("No information available")
     else
       ggplot(data = math) + 
       geom_point(aes(x = year, y = math50)) + 
       geom_smooth(aes(x = year, y = math50), method = lm, color = "black") + 
       geom_line(aes(x = year, y = math25), color = "red") +
       geom_line(aes(x = year, y = math75), color = "red") +
       scale_x_continuous(breaks=math$year) + ylab("Math score")+theme_wsj()}
   else
     ggplot() + ggtitle("Select a university")
 })
 
 ###SAT
 output$sat_cr <- renderPlot({
   loc = which(sat$INSTNM==input$university1)
   if (length(input$university1)){
     cr = data_frame(year = 2008:2017,
                     cr50 = as.numeric(unlist(sat[loc, seq(5,73,7)])),
                     cr25 = as.numeric(unlist(sat[loc, seq(4,73,7)])),
                     cr75 = as.numeric(unlist(sat[loc, seq(6,73,7)])))
     if (is.na(sum(cr$cr50)))
       ggplot() + ggtitle("No information available")
     else
       ggplot(data = cr) + 
       geom_point(aes(x = year, y = cr50)) + 
       geom_smooth(aes(x = year, y = cr50), method = lm, color = "black") + 
       geom_line(aes(x = year, y = cr25), color = "red") +
       geom_line(aes(x = year, y = cr75), color = "red") +
       scale_x_continuous(breaks=cr$year) + ylab("Critical Reading")+theme_wsj()}
   else
     ggplot() + ggtitle("Select a university")
 })
 output$sat_math <- renderPlot({
   loc = which(sat$INSTNM==input$university1)
   if (length(input$university1)){
     math = data_frame(year = 2008:2017,
                       math50 = as.numeric(unlist(sat[loc, seq(8,73,7)])),
                       math25 = as.numeric(unlist(sat[loc, seq(7,73,7)])),
                       math75 = as.numeric(unlist(sat[loc, seq(9,73,7)])))
     if (is.na(sum(math$math50)))
       ggplot() + ggtitle("No information available")
     else
       ggplot(data = math) + 
       geom_point(aes(x = year, y = math50)) + 
       geom_smooth(aes(x = year, y = math50), method = lm, color = "black") + 
       geom_line(aes(x = year, y = math25), color = "red") +
       geom_line(aes(x = year, y = math75), color = "red") +
       scale_x_continuous(breaks=math$year) + ylab("Math")}
   else
     ggplot() + ggtitle("Select a university")
 })
 output$sat_eq <- renderPlot({
   loc = which(sat$INSTNM==input$university1)
   if (length(input$university1)){
     eq = data_frame(year = 2008:2017,
                     eq_mean = as.numeric(unlist(sat[loc, seq(10,73,7)])))
     if (is.na(sum(eq$eq50)))
       ggplot() + ggtitle("No information available")
     else
       ggplot(data = eq) + 
       geom_point(aes(x = year, y = eq_mean)) + 
       geom_smooth(aes(x = year, y = eq_mean), method = lm, color = "black") +
       scale_x_continuous(breaks=eq$year) + ylab("Equivalent")+theme_wsj()}
   else
     ggplot() + ggtitle("Select a university")
 })
 
 ## Tuition and Fee
 output$in_fee <- renderPlot({
   loc = which(cost$INSTNM==input$university1)
   if (length(loc)){
     cost = data_frame(year = 2008:2017,
                       tuition = as.numeric(unlist(cost[loc, seq(4,23,2)])))
     if (is.na(sum(cost$cost)))
       ggplot() + ggtitle("Missing data")
     else
       ggplot(data = cost) +
       geom_point(aes(x = year, y = tuition)) + 
       geom_smooth(aes(x = year, y = tuition), method = lm) +
       scale_x_continuous(breaks=cost$year) + ylab("In-state Cost")+theme_wsj()}
   else
     ggplot() + ggtitle("Select a university")
 })
 
 output$out_fee <- renderPlot({
   loc = which(cost$INSTNM==input$university1)
   if (length(loc)){
     cost = data_frame(year = 2008:2017,
                       tuition = as.numeric(unlist(cost[loc, seq(5,23,2)])))
     if (is.na(sum(cost$cost)))
       ggplot() + ggtitle("No information available")
     else
       ggplot(data = cost) +
       geom_point(aes(x = year, y = tuition)) + 
       geom_smooth(aes(x = year, y = tuition), method = lm) +
       scale_x_continuous(breaks=cost$year) + ylab("In-state Cost")+theme_wsj()}
   else
     ggplot() + ggtitle("Select a university")
 })
}




