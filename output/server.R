#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#


library(shiny)
library(ggplot2)
library(dplyr)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  ## Basic Information 
  output$url <- renderUI({
    university <- basic[which(basic$INSTNM==input$university),]
    url = a(university$INSTNM, 
            href = paste0("http://",tolower(university$INSTURL)))
  })
  
  output$table <- renderTable({
    university <- basic[which(basic$INSTNM==input$university),]
    Items<-c("city", "Rank", "Admission rate",'Control of Institution', 
             'Highest Degree Awarded', 'Average family income')
    Value<-c(university$CITY, university$Ranking, as.numeric(university$ADM_RATE),
             university$CONTROL, university$HIGHDEG, as.numeric(university$FAMINC))
    data.frame(cbind(Items, Value))
  })
  
  ## Academics
  output$academics <- renderPlot({
    loc = which(academics$INSTNM==input$university)
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
    loc = which(adm_rate$INSTNM==input$university)
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
    loc = which(act$INSTNM==input$university)
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
    loc = which(act$INSTNM==input$university)
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
    loc = which(act$INSTNM==input$university)
    if (length(input$university)){
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
    loc = which(sat$INSTNM==input$university)
    if (length(input$university)){
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
    loc = which(sat$INSTNM==input$university)
    if (length(input$university)){
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
    loc = which(sat$INSTNM==input$university)
    if (length(input$university)){
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
    loc = which(cost$INSTNM==input$university)
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
    loc = which(cost$INSTNM==input$university)
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
})
