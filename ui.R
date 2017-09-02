#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Old Faithful Geyser Data with density estimates"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      radioButtons("variable", 
                   "Select variable to explore:",
                   choices = c("Eruptions" = "eruptions", 
                               "Waiting Time" = "waiting", 
                               "Density" = "density")),
      selectInput("graphCol", 
                  "Select color of the graph:",
                  c("blue", "green", "red", "gray", "black")),
      radioButtons("graphType",
                   "Select type of the graph:",
                   c("LineGraph", "Histogram", "Box-And-Whisker-Plot")),
      htmlOutput("histSlider"),
      tableOutput("summary")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("distPlot"),
       textOutput("overview1"),
       textOutput("overview2"))
  )
))
