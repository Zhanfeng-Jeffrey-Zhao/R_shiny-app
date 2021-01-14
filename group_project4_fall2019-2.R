# PROJECT 4
#
# Emily Curcio
# Koushik Manjunath
# Xiumin (Echo) Sun
# Zhanfeng (Jeffrey) Zhao

# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.

# Install required packages if needed
#install.packages("shiny")
#install.packages("leaflet")
#install.packages("DT")
#install.packages("shinythemes")
#install.packages("shinyWidgets")

# Load required packages
library(shinyWidgets)
library(leaflet)
library(shiny)
library(DT)
library(shinythemes)

# Set working directory and make sure dataset file is in this location
#setwd("/Users/Zhanfeng/R")

# Load data
AB_NYC_2019 <- read.csv("AB_NYC_2019.csv", header = TRUE)

# Define UI
ui <- fluidPage(theme = shinytheme("cerulean"),
                navbarPage(
                  title = 'Catagory Options',
                  tabPanel("Seach Listing",
                           tags$img(src = "https://www.fodors.com/wp-content/uploads/2016/02/1-Ultimate-New-York-Hero.jpg",
                                    style = 'position: absolute; opacity: 0.5;'), #Insert a picture as background
                           fluidRow(column(12, div(dataTableOutput("table"))))), #Generate interactive table
                  tabPanel("Availability",
                           selectInput(inputId = "borough",  #Generate a drop-down filter to select borough
                                       label = "Select a borough",
                                       choices = unique(AB_NYC_2019$neighbourhood_group),
                                       selected = "The Bronx"),
                           sliderInput(inputId = "price",  #Generate a slider to select a price range
                                       label = "Slide to a price range",
                                       value = c(50,100),
                                       min = 1,
                                       max = 300),
                           submitButton(text = 'submit'),
                           plotOutput("hist"),
                           verbatimTextOutput("stats")),
                  tabPanel("Price by Region",  #Give the page a title
                           tags$img(src = "https://www.fodors.com/wp-content/uploads/2016/02/1-Ultimate-New-York-Hero.jpg",
                                    style = 'position: absolute; opacity: 0.5;'), #Insert a picture as background
                           sidebarLayout(sidebarPanel( #Generate a row with a sidebar
                             selectInput("region", "Region:", #Generate a drop-down filter for region
                                         choices = AB_NYC_2019$neighbourhood_group,
                                         selected = "The Bronx",
                                         multiple = F),
                             selectInput(inputId = "n_breaks", #Generate a drop-down filter for bins in histogram
                                         label = "Number of bins in histogram (approximate):",
                                         choices = c(10, 30, 50, 100),
                                         selected = 30),
                             sliderInput("y", #Generate a slider to adjust ylim
                                         "Ylim:",
                                         min = 1,  max = 5000, value = 2000),   
                             sliderInput("x", #Generate a slider to adjust xlim
                                         "Xlim:",
                                         min = 1,  max = 5000, value = 2000), 
                             submitButton(text = 'submit')
                             ),
                             mainPanel(
                               uiOutput("price_regionPlot")
                               )
                             )),
                  tabPanel("Distrubution Map",  #Set the page title
                           headerPanel(title = 'NY Airbnb Housing Distribution'),  #Set the filter title
                           sidebarLayout(sidebarPanel(selectInput(inputId = 'Col',label = 'District',  #Generate a drop-down filter to choose the distrci for mapping
                                                                  choices = c('Bronx','Brooklyn','Manhattan','Queens','Staten Island'),
                                                                  selected = c('Manhattan'),  #Set the default value is "Manhattan"
                                                                  multiple = F),
                                                      submitButton(text='submit')),
                                         mainPanel( uiOutput("leafmap")))
                           )))

# Define server function
server <- function(input, output) {
  output$table <- renderDT(
    subset(AB_NYC_2019, select = -c(1,3,7,8,13,14,15)), #Select most relevant columns to display in table
    class = "display nowrap compact",
    filter = "top"
    )
  output$hist <- renderPlot({
    availability <- AB_NYC_2019$availability_365[AB_NYC_2019$neighbourhood_group==input$borough & AB_NYC_2019$price==input$price]
    hist(availability,  #Create a histogram for availability by borough and price
         main = input$borough,
         col = "light green",
         xlab = "Number of Days Available Out of the Year",
         xlim = c(0,360))
    })
  output$stats <- renderPrint({
    availability <- AB_NYC_2019$availability_365[AB_NYC_2019$neighbourhood_group == input$borough & AB_NYC_2019$price==input$price]
    summary(availability)
    })
  output$price_regionPlot = renderUI({
    plotOutput('price_region', height = 800)
    })
  output$price_region <- renderPlot({
    AB_NYC_2019 <-na.omit(AB_NYC_2019)  #Omit NA value in the dataset
    group_price <- AB_NYC_2019[c("neighbourhood_group","price")]  #Create a dataframe only with region and price
    hist(subset(group_price,neighbourhood_group==input$region)$price,  #Create a histogram for price by region
         main = input$region,
         breaks = as.numeric(input$n_breaks),
         col = "light blue",
         ylab = "Number",
         xlab = "Price",
         ylim = c(1,input$y),
         xlim = c(1,input$x)
         )
    })
  output$leafmap=renderUI({  #Set map size
    leafletOutput('Distribution_Map', height = 850)
    })
  output$Distribution_Map=renderLeaflet({
    da <- subset(AB_NYC_2019, AB_NYC_2019$neighbourhood_group == input$Col)  #Choose the district subdate which user chosen by fliter
    da %>% leaflet() %>% addTiles() %>% addCircles()  #Graph the distribution map based on the subdate user chosen on fliter
  })
  }

# Create Shiny object
shinyApp(ui = ui, server = server)
