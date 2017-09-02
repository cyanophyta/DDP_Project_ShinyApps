#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(data.table)
library(ggplot2)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  varIndex <- reactive({
    return(switch(input$variable,
                  "eruptions" = 1, 
                  "waiting" = 2,
                  "density" = 3))
  })
  
  varName <- reactive({
    return(switch(input$variable, 
                  "eruptions" = "Eruptions",
                  "waiting" = "Waiting Time (in minutes)",
                  "density" = "Density"))
  })
  slider <- reactive({
    graphType <- input$graphType
    if(graphType == "Histogram") {
      sliderInput("bins",
                  "Number of intervals to group data:",
                  min = 1,
                  max = 50,
                  value = 20)    
    } else {
      return(NULL)
    }
    
  })
  
  output$overview1 <- renderText({
    "Package ggplot2 contians faithfuld dataset which contains data on 
eruptions from Old Faithful Geyser along with density estimates. This dataset
records three variables, viz. Eruptions, Density and Waiting time between 
eruptions, measured in minutes.
    "
  })
  
  output$overview2 <- renderText({
    "Here we plot Histograms or Line Graphs or Box-and-whisker Plots of one of
these three variables. Using various controls in the navigation pane on the
left side, please select one of these three variables to explore, the type 
of graph to be displayed and color of the graph. For histogram, there is an 
additional way of selecting the number of intervals to be used for the graph. 
By default, 20 intervals will be used to group the data for displaying histogram.
    "
  })

  output$histSlider <- renderUI({
    slider()
  })
  
  output$summary <- renderTable({
    mydf <- as.data.frame(faithfuld)
    x    <- mydf[, varIndex()] 
    summat <- as.matrix(summary(x))
    rownames(summat) <- c("Minimum", "1st quartile", "Median", 
                          "Mean", "3rd quartile", "Maximum")
    colnames(summat) <- "Summary"
    return(summat)
  }, rownames = TRUE)
  
  output$distPlot <- renderPlot({
    #gather other inputs
    color <- input$graphCol
    graphType <- input$graphType
    
    mydf <- as.data.frame(faithfuld)
    x    <- mydf[, varIndex()] 
    if(graphType == "Histogram" & !is.null(input$bins)) {
      # generate bins based on input$bins from ui.R
      bins <- seq(min(x), max(x), length.out = input$bins + 1)
      
      # draw the histogram with the specified number of bins
      hist(x, 
           breaks = bins, 
           col = color, 
           border = 'white', 
           main = paste("Histogram of ", varName()), 
           xlab = varName())      
    } else if(graphType == "LineGraph") {
      #draw Line Graph
      plot(x, 
           type = "l", 
           col = color, 
           main = paste("LIne Graph of ", varName()), 
           xlab = "Index", 
           ylab = varName())
    } else if(graphType == "Box-And-Whisker-Plot") {
      #draw Box-and-Whisker Plot
      boxplot(x, 
              col = color, 
              main = paste("Box and Whisket Plot of ", varName()),
              xlab = varName())
    }
  })
  
})
