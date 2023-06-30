#
# autothemeR application.
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

# Establish General Environment ----------------------------------------------------------
# Environment Setup ----------------------------------------------------------------------

# Packages -------------------------------------------------------------------------------
# set libpath to global package environment:
# packages:
if(!require("shiny")) {install.packages("shiny")}
library(shiny)

if(!require("tidyverse")) {install.packages("tidyverse")}
library(tidyverse)
library(magrittr)

if(!require("readxl")) {install.packages("readxl")}
library(readxl)

if(!require("janitor")) {install.packages("janitor")}
library(janitor)

if(!require("tidytext")) {install.packages("tidytext")}
library(tidytext)

if(!require("topicmodels")) {install.packages("topicmodels")}
library(topicmodels)

if(!require("LDAvis")) {install.packages("LDAvis")}
library(LDAvis)

# sessionInfo()
# R version 4.1.1 (2021-08-10)
# Platform: x86_64-w64-mingw32/x64 (64-bit)
# Running under: Windows 10 x64 (build 19045)
# 
# Matrix products: default
# 
# locale:
#   [1] LC_COLLATE=English_United Kingdom.1252  LC_CTYPE=English_United Kingdom.1252    LC_MONETARY=English_United Kingdom.1252
# [4] LC_NUMERIC=C                            LC_TIME=English_United Kingdom.1252    
# 
# attached base packages:
#   [1] stats     graphics  grDevices utils     datasets  methods   base     
# 
# other attached packages:
#   [1] LDAvis_0.3.2       topicmodels_0.2-13 tidytext_0.4.1     janitor_2.2.0      readxl_1.4.2       magrittr_2.0.3    
# [7] lubridate_1.9.2    forcats_1.0.0      stringr_1.5.0      dplyr_1.1.0        purrr_1.0.1        readr_2.1.4       
# [13] tidyr_1.3.0        tibble_3.1.8       ggplot2_3.4.1      tidyverse_2.0.0   
# 
# loaded via a namespace (and not attached):
#   [1] xfun_0.39         modeltools_0.2-23 tidyselect_1.2.0  slam_0.1-50       NLP_0.2-1         reshape2_1.4.4   
# [7] lattice_0.20-44   snakecase_0.11.0  colorspace_2.1-0  vctrs_0.5.2       generics_0.1.3    SnowballC_0.7.0  
# [13] stats4_4.1.1      utf8_1.2.3        rlang_1.1.0       later_1.3.0       pillar_1.8.1      glue_1.6.2       
# [19] withr_2.5.0       lifecycle_1.0.3   plyr_1.8.8        munsell_0.5.0     gtable_0.3.1      cellranger_1.1.0 
# [25] labeling_0.4.2    tzdb_0.3.0        httpuv_1.6.9      tm_0.7-11         parallel_4.1.1    fansi_1.0.4      
# [31] tokenizers_0.3.0  Rcpp_1.0.10       promises_1.2.0.1  scales_1.2.1      jsonlite_1.8.4    mime_0.12        
# [37] farver_2.1.1      servr_0.27        hms_1.1.3         stringi_1.7.12    RJSONIO_1.3-1.8   grid_4.1.1       
# [43] cli_3.6.1         tools_4.1.1       proxy_0.4-27      janeaustenr_1.0.0 pkgconfig_2.0.3   Matrix_1.5-3     
# [49] xml2_1.3.3        timechange_0.2.0  rstudioapi_0.14   R6_2.5.1          compiler_4.1.1

# Function to run LDA analysis on a dataframe called df and result in elements for LDAvis
# Function to perform LDA analysis and return final objects as a dataframe
# Function to perform LDA analysis and return final objects as a dataframe
performLDA <- function(df, k) {
  
  # Take df and refine
  df <- df %>%
    select(1, 2) %>%
    na.omit()
  
  # Tidytext preprocessing to create count of words per person
  word_counts.df <- df %>%
    unnest_tokens(output = word, input = text) %>%
    anti_join(stop_words) %>%
    count(id, word, sort = FALSE)
  
  # Create total word count across all responses
  total_word_count.df <- df %>%
    unnest_tokens(output = word, input = text) %>%
    group_by(word) %>% summarise(total = n())
  
  # Form final word_count.df before cast to dtm
  word_counts.df <- word_counts.df %>%
    left_join(total_word_count.df) %>%
    filter(total > 1) %>%
    select(-c(total))
  
  # Cast to DTM
  dtm <- word_counts.df %>%
    cast_dtm(data = ., document = id, term = word, value = n)
  
  # Building topic model through LDA
  lda <- topicmodels::LDA(x = dtm,
                          k = k,
                          method = "Gibbs",
                          control = list(seed = 47, alpha = 0.1))
  
  # Get posterior from fitted lda model
  lda_posterior <- posterior(lda)
  
  # Use posterior to create each of the elements for the JSON object
  dtm <- dtm[slam::row_sums(dtm) > 0, ]
  
  phi <- as.data.frame(as.matrix(lda_posterior$terms))
  theta <- as.data.frame(as.matrix(lda_posterior$topics))
  vocab <- colnames(phi)
  doc.length <- slam::row_sums(dtm)
  term.freq <- slam::col_sums(dtm)[match(vocab, colnames(dtm))]
  
  # List required objects
  list(phi = phi, theta = theta, vocab = vocab, doc.length = doc.length, term.freq = term.freq)

}

# UI -------------------------------------------------------------------------------------

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application Title ------------------------------------------------------------------
  titlePanel("Nate's AutothemeR (in development)"),
  
  # Sidebar for inputs -----------------------------------------------------------------
  sidebarPanel(
    
    # input (file1): select a file:
    fileInput("file1", "Choose Excel File", multiple = FALSE, placeholder = "upload file"),
    
    # slider (nTerms): to choose number of terms to display in topic_plot
    sliderInput("nTerms", "Number of terms to display", min = 10, max = 50, value = 10),
    
    # slider (kSelector): to choose the number of topics to display in topic_plot
    sliderInput("kSelector", "Number of topics to create", min = 3, max = 50, value = 3)
    
  ),
  
  
  # Main Panel ------------------------------------------------------------------------- 
  
  # output diplay
  mainPanel(
    
    # tabset output: file view, topic view
    tabsetPanel(type = "tabs",
                tabPanel("input_file", tableOutput("input_file")),
                tabPanel("topic_plot", visOutput("topic_plot")))
    
  ),
  
  # Conditional Panel --------------------------------------------------------------------
  conditionalPanel(condition = "$('#topic_plot').hasClass('recalculating')"),
    tags$div('Stuff will load I promise - it just it may take a sec :)...')
  
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
  
  performLDA(df, input$kSelector)
  
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

