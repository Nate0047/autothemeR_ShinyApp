#
# UCLan autothemeR application.
#
# an application that takes text data and conducts LDA with interactive visual for user
# to interact with end themes.
#
#
# General Info:
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
# Set libPath and add shiny package
.libPaths("C:/R library")
library(shiny)

# Establish General Environment ----------------------------------------------------------
source("environment.r")

# UI -------------------------------------------------------------------------------------

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application Title ------------------------------------------------------------------
    titlePanel("UCLan AutothemeR"),

    # Sidebar for inputs -----------------------------------------------------------------
    sidebarPanel(
      
      # input: select a file:
      fileInput("file1", "Choose Excel File",
                multiple = FALSE,
                placeholder = "upload Excel file"),

    ),
    
    # Main Panel ------------------------------------------------------------------------- 

      # output: data file
      mainPanel(
         tableOutput("input_file")
      )
)

# Server ---------------------------------------------------------------------------------

# Define server logic required to draw a histogram
server <- function(input, output) {
  

  # Main Panel Outputs -------------------------------------------------------------------
  output$input_file <- renderTable({
    
    req(input$file1)
    
    df <- read_excel(path = input$file1$datapath, col_names = TRUE)
    
    return(df)
    
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)

