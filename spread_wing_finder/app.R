# Attach necessary packages
library(tidyverse)
library(shiny)
library(shinythemes)
library(rsconnect)
rsconnect::setAccountInfo(name='eltingrosalee', token='C4A30BF752FCCC69631C3EB735764E4B', secret='U9Cvo7bLdpQwe2IxztLyk6NxI/+bt/cZA9M8u++V')

wings <- read_csv("spread_wings_full_directory_cleaned.csv")


# Create the user interface:
ui <- fluidPage(theme= shinytheme("slate"),
                sidebarLayout(
                  sidebarPanel(selectInput("museum", "Choose your museum:", 
                                           choices = unique(wings$institution)),
                               radioButtons("clade", "Select a clade:", 
                                            choices = unique(wings$clade)),
                               h6("Powered by:",height =20),
                               tags$img(src='be_logo.png', align = "left", height=100, width=100)),
                  mainPanel(tableOutput("wingsdata"),
                  fluid=TRUE)))
# Create the server function:
server <- (function(input, output) {
  output$wingsdata <- renderTable({
    museumFilter <- subset(wings, wings$institution== input$museum & wings$clade == input$clade, c("institution", "clade", "genus", "specificepithet", "infraspecificepithet", "vernacularname", "sex", "catalognumber"))
  })
})

# Combine them into an app:
shinyApp(ui = ui, server = server)

