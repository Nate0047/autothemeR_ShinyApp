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
#setwd("C:/Users/NBirdsall2/OneDrive - UCLan/_UCLan - RF in Policing/Tool Building/UCLan autothemeR/UCLan_autothemeR")

# Establish General Environment ----------------------------------------------------------
source("environment.r")

# Function to run LDA analysis on a dataframe called df and result in elements for LDAvis
# Function to perform LDA analysis and return final objects as a dataframe
source("lda function.r")

# UI -------------------------------------------------------------------------------------

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application Title ------------------------------------------------------------------
  titlePanel("UCLan AutothemeR (in development)"),
  
  # Sidebar for inputs -----------------------------------------------------------------
  sidebarPanel(
    
    # input (file1): select a file:
    fileInput("file1", "Choose Excel File", multiple = FALSE, placeholder = "upload file"),
    
    # slider (nTerms): to choose number of terms to display in topic_plot
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
    
    df <- read_excel(input$file1$datapath, col_names = TRUE)
    
    #plot
    return(df)
    
  })

  # topic_plot output --------------------------------------------------------------------
  # build reactive pipeline of raw data to ldaVis induction
  lda_feeder <- reactive({
  
  require(input$file1)
  
  df <- readxl::read_excel(path = input$file1$datapath, col_names = TRUE)
  
  performLDA(df)
  
  })

  # build topic_plot visual
  output$topic_plot <- renderVis({
    
    lda_data <- lda_feeder()
    
    # build the elements into the json object for ldaVis package to run
    createJSON(phi = lda_data$phi, 
                            theta = lda_data$theta,
                            vocab = lda_data$vocab, 
                            doc.length = lda_data$doc.length,
                            term.frequency = lda_data$term.freq,
                            R = input$nTerms)
    
    })
  
}
    
# Run the application 
shinyApp(ui = ui, server = server)

