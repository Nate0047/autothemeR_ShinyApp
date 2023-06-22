# Function to perform LDA analysis and return final objects as a dataframe
performLDA <- function(df) {
  
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
                          k = 10,
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
  
  
  # # build the elements into the json object for ldaVis package to run
  # createJSON(phi = phi,
  #              theta = theta,
  #              vocab = vocab,
  #              doc.length = doc.length,
  #              term.frequency = term.freq,
  #              R = input$nTerms)

}