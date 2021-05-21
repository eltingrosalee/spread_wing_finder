# Attach necessary packages
library(tidyverse)
library(shiny)
library(shinythemes)

wings <- read_csv("spread_wings_full_directory_cleaned.csv")


# Create the user interface:
ui <- fluidPage(theme= shinytheme("slate"),
  sidebarLayout(
    sidebarPanel(selectInput("museum", "Choose your museum:", 
                            choices = unique(wings$institution))),
  mainPanel(tableOutput("wingsdata")),
  fluid=TRUE))
# Create the server function:
server <- (function(input, output) {
 output$wingsdata <- renderTable({
   museumFilter <- subset(wings, wings$institution== input$museum, c("institution", "clade", "genus", "specificepithet", "infraspecificepithet", "vernacularname", "sex", "catalognumber"))
   })
 
# Combine them into an app:
shinyApp(ui = ui, server = server)