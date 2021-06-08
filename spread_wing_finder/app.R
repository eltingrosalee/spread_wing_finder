# Attach necessary packages 
library(tidyverse)
library(shiny)
library(shinythemes)
library(rsconnect)
library(shinyWidgets)
library(gitcreds)
#rsconnect for publishing the app 
rsconnect::setAccountInfo(name='eltingrosalee', token='C4A30BF752FCCC69631C3EB735764E4B', secret='U9Cvo7bLdpQwe2IxztLyk6NxI/+bt/cZA9M8u++V')
#setting up GH token using git creds package 

#inputting data 
wings_csv <- read_csv("spread_wings_full_directory_cleaned.csv")
#saving as a data frame
wings <- data.frame(wings_csv)
#renaming Columns
colnames(wings) <- c("Code","Institution", "Collection Catalog", "Catalog Number", "Record Number", "Scientific Name",
                     "Kingdom", "Phylum", "Class", "Order", "Family", "Clade", "Genus", "Subgenus", "Species", "Subspecies", 
                     "Taxon Rank", "Verbatum Taxon Rank", "Common Name", "Sex")



# Create the user interface:
ui <- fluidPage(theme= shinytheme("slate"),
                titlePanel(h1(strong("Spread Wing Finder"), style = "font-size:40px;")),
                sidebarLayout(
                  sidebarPanel(pickerInput("museum", "Choose your museum:", 
                                           choices = unique(wings$Institution),options = list(`actions-box` = TRUE),multiple = T, selected = "University of Washington Burke Museum"),
                               awesomeCheckboxGroup("clade", "Clade:", 
                                            choices = unique(wings$Clade), width =1, status= "info"),
                               pickerInput("sex", "Select sex of interest:",
                                           choices = unique(wings$Sex), selected = "male", options = list(`actions-box` = TRUE),multiple = T),
                               h4("Created by", a(href="https://rosaleeelting.wixsite.com/mysite","Rosalee Elting")),
                               h5("To see what else our lab is working on", a(href="https://rosaleeelting.wixsite.com/mysite","click here!")),
                               tags$img(src='be_logo.png', align = "left", height=200, width=200),
                               br(), br(), br(), br(),br(), br(),br(), br(),br(), br(),
                               h6("Behavioral Ecophysics Lab, University of Washington, Seattle, WA "),
                               h6("Data Provided by", a(href="http://vertnet.org/", "Vertnet"))),
                  mainPanel(titlePanel(h1("Wings Available:", align = "center",style = "font-size:20px;")),tableOutput("wingsdata"),
                  fluid=TRUE)))
# Create the server function:
server <- (function(input, output) {
  output$wingsdata <- renderTable({ subset(wings, wings$Institution== input$museum & wings$Clade == input$clade & input$sex == wings$Sex, 
                                           c("Institution", "Common Name", "Genus", "Species", "Subspecies", "Clade", "Sex", "Catalog Number"))
    })
})

# Combine them into an app:
shinyApp(ui = ui, server = server)

