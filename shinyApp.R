library(shiny)
library(colourpicker)
library(dplyr)
library(ggplot2)
library(zoo)
library(tidyverse)
library(patchwork)
library(corrplot)

##########
### UI ###
##########

# Define UI for application that draws a histogram
ui <- navbarPage("application RShiny",
                 tabPanel("premier onglet",
                          
                          navlistPanel(
                            "sélectionner l'onglet désiré",
                            tabPanel("plot",
                                     
                                     # Sidebar with a slider input for number of bins
                                     fluidRow(#remplace sidebarLayout, column(... remplace sidebarPanel et mainPanel
                                       
                                       column(width = 3,#sliderInput(... occupera (3+9)/12 = 3/4 de la page
                                              sliderInput("bins",
                                                          "Number of bins:",
                                                          min = 1,
                                                          max = 50,
                                                          value = 30),
                                              colourInput(inputId = "color", label = "Couleur :",
                                                          value = "#90B8B7",
                                                          palette = c("square","limited"))
                                       ),
                                       
                                       # Show a plot of the generated distribution
                                       column(width = 9,#plotOutput(... occupera (3+9)/12 = 3/4 de la page
                                              plotOutput("distPlot")
                                       ),
                                       
                                     )#fin de fluidRow
                            ),#fin du tabPanel1
                            
                            tabPanel("summary",
                                     verbatimTextOutput("summary")# Table output here
                                     )
                          ),#fin du tabPanel2
                 ),
                 tabPanel("deuxième onglet",
                          fluidRow(
                            textOutput("textOutput"),
                                   h4("weather"),
                                   tableOutput("dataTable"),
                                   verbatimTextOutput("dataTable2"),
                            
                            dateInput("selected_date", "Select a date:",
                                      value = Sys.Date(), format = "yyyy-mm-dd"),
                            
                            # Location input for the user
                            selectInput("selected_location", "Select a location:",
                                        choices = unique(sample_data$location))                          
                            ),
                          column(width = 9,
                                 plotOutput("distPlot"),
                                 h4("Selected Row of Data"),
                                 tableOutput("filteredData") # Table output for the selected row
                          )
                          
                 ),
                 
)



##############
### Server ###
##############

server <- function(input, output) {
  
  # Histogram plot
  output$distPlot <- renderPlot({
    # Get the Old Faithful Geyser data
    x <- faithful$eruptions
    # Create bins based on input$bins from ui.R
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # Draw the histogram with the selected number of bins and color
    hist(x, breaks = bins, col = input$color, border = 'white', main = "Histogram of Old Faithful Eruptions", xlab = "Eruption duration (mins)")
  })
  
  # Summary of the geyser data
  output$summary <- renderPrint({
    summary(faithful$eruptions)
  })
  
  #weather data
  library(dplyr)
  df1<-read.table("PRSA_Data_Aotizhongxin_20130301-20170228.csv",sep = ",",header = TRUE,
                  stringsAsFactors = TRUE)
  df2<-read.table("PRSA_Data_Changping_20130301-20170228.csv",sep=",",header = TRUE,stringsAsFactors = TRUE)
  df3<-read.table("PRSA_Data_Dingling_20130301-20170228.csv",sep = ",",header = TRUE,
                  stringsAsFactors = TRUE)
  df4<-read.table("PRSA_Data_Dongsi_20130301-20170228.csv",sep=",",header = TRUE,stringsAsFactors = TRUE)
  df5<-read.table("PRSA_Data_Guanyuan_20130301-20170228.csv",sep = ",",header = TRUE,
                  stringsAsFactors = TRUE)
  df6<-read.table("PRSA_Data_Gucheng_20130301-20170228.csv",sep=",",header = TRUE,stringsAsFactors = TRUE)
  df7<-read.table("PRSA_Data_Huairou_20130301-20170228.csv",sep = ",",header = TRUE,
                  stringsAsFactors = TRUE)
  df8<-read.table("PRSA_Data_Nongzhanguan_20130301-20170228.csv",sep=",",header = TRUE,stringsAsFactors = TRUE)
  df9<-read.table("PRSA_Data_Shunyi_20130301-20170228.csv",sep = ",",header = TRUE,
                  stringsAsFactors = TRUE)
  df10<-read.table("PRSA_Data_Tiantan_20130301-20170228.csv",sep=",",header = TRUE,stringsAsFactors = TRUE)
  df11<-read.table("PRSA_Data_Wanliu_20130301-20170228.csv",sep = ",",header = TRUE,
                   stringsAsFactors = TRUE)
  df12<-read.table("PRSA_Data_Wanshouxigong_20130301-20170228.csv",sep=",",header = TRUE,stringsAsFactors = TRUE)
  df<-bind_rows(df1,df2,df3,df4,df5,df6,df7,df8,df9,df10,df11,df12)
  df$avg_temp_last_7 <- rollapply(df$TEMP, width = 7, FUN = mean, align = "right", fill = NA, partial = TRUE)
  

  # Render the table for the Old Faithful dataset
  output$dataTable <- renderTable({
    head(df) # Show the first few rows of the dataset
  })
  output$dataTable2 <- renderPrint({
    summary(df)
  })
  
  
  # Filter data based on selected date and location
  output$filteredData <- renderTable({
    filtered_row <- subset(sample_data, date == input$selected_date & location == input$selected_location)
    if (nrow(filtered_row) == 0) {
      return(data.frame(message = "No data found for the selected date and location."))
    }
    filtered_row
  })
  
  
  # Render some text in the second tab
  output$textOutput <- renderText({
    "This is the second tab, where you can add additional information or components."
  })
}





###########
### run ###    :)
###########

shinyApp(ui = ui, server = server)
