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
setwd("C:/Users/NBirdsall2/OneDrive - UCLan/_UCLan - RF in Policing/Tool Building/UCLan autothemeR/UCLan_autothemeR")

# Establish General Environment ----------------------------------------------------------
source("environment.r")

# UI -------------------------------------------------------------------------------------

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application Title ------------------------------------------------------------------
  titlePanel("UCLan AutothemeR (in development)"),
  
  # Sidebar for inputs -----------------------------------------------------------------
  sidebarPanel(
    
    # input: select a file:
    fileInput("file1", "Choose Excel File", multiple = FALSE, placeholder = "upload file"),
    
    # slider: to choose number of terms to display in topic_plot
    sliderInput("nTerms", "Number of terms to display", min = 20, max = 40, value = 30),
    
  ),
  
  
  # Main Panel ------------------------------------------------------------------------- 
  
  # output diplay
  mainPanel(
    
    # tabset output: file view, topic view
    tabsetPanel(type = "tabs",
                tabPanel("input_file", tableOutput("input_file")),
                tabPanel("topic_plot", visOutput("topic_plot")))
    
  )
  
)

# Server ---------------------------------------------------------------------------------

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  # Main Panel Outputs -------------------------------------------------------------------
  
  # input_file output --------------------------------------------------------------------
  output$input_file <- renderTable({
    
    req(input$file1)
    
    df <- read_excel(path = input$file1$datapath, col_names = TRUE)
    
    return(df)
    
  })

  # topic_plot output --------------------------------------------------------------------
  
  # build reactive pipeline of raw data to ldaVis induction
 df <- reactive({read_excel(path = input$file1$datapath, col_names = TRUE)})
  
#-----------------------------------------------------------------------------------------
  # NEED TO FIND SOME WAY OF PIPING FILE HERE!
#-----------------------------------------------------------------------------------------
  
  # build topic_plot visual
  output$topic_plot <- renderVis({
    
    
    # build the elements into the json object for ldaVis package to run
    json <- 
      createJSON(phi = phi, 
                 theta = theta, 
                 vocab = vocab, 
                 doc.length = doc.length, 
                 term.frequency = term.freq,
                 R = input$nTerms)
    
    return(json)
    
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)

