library(plotly)
library(ggthemes)
library(shiny)
library(reshape2)
library(parcoords)
library(stringr)
library(RColorBrewer)
library(geosphere)
library(formattable)
library(dplyr)

data_c=read.csv("data_compare_3.csv",header = TRUE)
data_c$Unemployment.Rate <- data_c$Unemployment.Rate/100

shinyServer(function(input, output) {

  output$universities.table = renderDataTable({
    s=input$university
    if(length(s)){
    data_list<- data_c %>% dplyr::select(College,Rank,City,State,Region,
                                       City.size,Control,Highest.Degree) %>% 
                                       filter (College %in% input$university)
    
    data.frame(data_list)
    
    }   
  })
  
  

output$tuitionPlot <- renderPlot({
    data_hist <- data_c %>% dplyr::select(1, Tuition.Fee.in.state,Tuition.Fee.out.state,
                                        Mean.Earnings.Female.Students,Mean.Earnings.Male.Students) %>% 
                                        filter (College %in% input$university)
    data_melt <- reshape2::melt(data_hist, id = "College")
    data_melt$value=as.numeric(data_melt$value)
    data_melt$value[is.na(data_melt$value)] <- 0
    ggplot(data=data_melt, aes(x=variable,y=value,fill=College))+
      geom_bar(stat="identity", width=.5,position=position_dodge((.7)))+
      guides(fill=guide_legend(title=NULL))+
      geom_text(aes(label = round(value,2)),position=position_dodge(width=0.9), vjust=-0.25)+
      theme_wsj()+
      theme(axis.title = element_blank(),legend.position = 'top')
  })

output$proportionPlot <- renderPlot({
  data_proportion <- data_c %>% dplyr::select(1,Female.Proportion,Married,
                                            Unemployment.Rate,Share.of.Students.Earning.over..25.000.year) %>% 
                                            filter (College %in% input$university)
  data_melt_proportion <- reshape2::melt(data_proportion, id = "College")
  data_melt_proportion$value=as.numeric(data_melt_proportion$value)
  data_melt_proportion$value[is.na(data_melt_proportion$value)] <- 0
  ggplot(data=data_melt_proportion, aes(x=variable,y=value,fill=College))+
    geom_bar(stat="identity", width=.5,position=position_dodge((.7)))+
    guides(fill=guide_legend(title=NULL))+
    geom_text(aes(label = round(value,2)), position=position_dodge(width=0.9), vjust=-0.25)+
    theme(axis.title = element_blank(),legend.position = 'top')+ 
    scale_y_continuous(breaks=seq(0,1,0.1))+
    theme_wsj()
})




output$par <- renderParcoords({
    data_Parcoords<-data_c %>% dplyr::select(1,Admission.Rate,ACT.score,
                                           SAT.score,Mean.Earnings.Students) %>% filter(College %in% input$university)
    parcoords(data_Parcoords, rownames = F
            , brushMode = "1d-axes"
            , reorderable = T
            , queue = F
            , color = list(
              colorBy = "College"
              , colorScale = htmlwidgets::JS("d3.scale.category10()"))
  )
}) 




})
