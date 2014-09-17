library(shiny)
library(ggplot2)
library(reshape2)
library(dplyr)
library(lubridate)
library(stringr)
library(ggthemes)

load("historical_melt.RData")
load("recent.RData")

theme_set(theme_bw() + theme(strip.background=element_blank(),
                             legend.title=element_blank(), 
                             text=element_text(family="sans")))

shinyServer(function(input, output) {

  output$recentPlot <- renderPlot({
    
    df_plot <- filter(recent, country != "Senegal")
    
    p_recent <- 
      ggplot(df_plot, 
           aes(x = date, y = value, group = variable, color = variable, fill = variable, shape = variable)) +
      facet_wrap(~country, scales = "free", ncol = 2) +
      geom_point(size = 0) +
      scale_color_few() +
      scale_fill_few() +
      theme(legend.position = c(0.60, 0.20)) +
      scale_x_datetime(limits = range(df_plot$date)) +
      labs(x = NULL, y = "Cases/Deaths")
      
    if(input$points)
      p_recent <- p_recent + geom_point()
    
    if(input$smooth)
      p_recent <- p_recent + geom_smooth(span = input$smoothSpan)
    
    print(p_recent)
  })
  
  output$historicalPlot <- renderPlot({
    
    p_historical <- 
      historical_melt %>% 
      ggplot(aes(x = year, y = value, fill = outcome)) +
      geom_bar(stat = "identity", position = "dodge") +
      scale_fill_few("medium") +
      guides(fill = guide_legend(reverse = TRUE)) +
      labs(x = NULL, y = "Number of cases")
    
    print(p_historical)
  })
  
  output$historicalTable <- renderTable(historical_melt %>% 
                                          mutate(year = as.character(year), 
                                                 value = as.integer(value)))

})