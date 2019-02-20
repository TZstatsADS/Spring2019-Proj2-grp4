library(plotly)
library(ggthemes)
library(shiny)
library(reshape2)
#data
data = read.csv("processed_data")

#data compare parcoord
data_compare_parcoord<-data.frame(data$INSTNM,data$ADM_RATE,data$ACTCMMID,data$SAT_AVG,data$MN_EARN_WNE_P10)
colnames(data_compare_parcoord)=c("College","Admission Rate","ACT score","SAT score","Earnings after 10 year entry")


#data compare tuition
data_compare_tuition<-data.frame(data$INSTNM,data$TUITIONFEE_IN,data$TUITIONFEE_OUT)
colnames(data_compare_tuition)=c("College","Tuition Fee in state","Tuition Fee out state")

shinyServer(function(input, output) {
data_parcoord<-
  sub_data<-reactive({list(data=data_compare_parcoord[data_compare_parcoord$College==as.character(input$university1) | 
                                                        data_compare_parcoord$College==as.character(input$university2) | 
                                                        data_compare_parcoord$College==as.character(input$university3),
                                              ])})
output$par <- renderParcoords({
  parcoords(sub_data()$data, rownames = F
            , brushMode = "1d-axes"
            , reorderable = T
            , queue = F
            , color = list(
              colorBy = "Carrier"
              , colorScale = htmlwidgets::JS("d3.scale.category10()"))
  )
}) 
  

output$carrierPlot <- renderPlot({

    col_name <- c(input$university1,input$university2,input$university3)
    col_row <- data_compare_tuition$College %in% col_name
    col_data <- data_compare_tuition[col_row,]
    data_melt <- reshape2::melt(col_data, id = "College")
    ggplot(data=data_melt, aes(x=variable,y=value,fill=College))+
      geom_bar(stat="identity", position=position_dodge())+
      guides(fill=guide_legend(title=NULL))+
      theme(axis.title = element_blank(),legend.position = 'top')+ 
      labs(x = "Delay Time in Minutes",y = "Percentage")
  
  
})
  
})  

  