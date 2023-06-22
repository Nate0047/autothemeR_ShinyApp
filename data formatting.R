# Data Formatting ------------------------------------------------------------------------

# tidytext to preprocess then cast to dtm for lda analysis

# Preprocessing --------------------------------------------------------------------------
#df <- read_excel("C:/Users/NBirdsall2/OneDrive - UCLan/_UCLan - RF in Policing/Tool Building/UCLan autothemeR/data/test data.xlsx")

df %<>%
  select(1, 2) %>%
  na.omit

# tidytext preprocessing to create count of words per person
word_counts.df <-
  
  df %>%
  
  # break down local_issues text into words
  unnest_tokens(output = word, input = text) %>%
  
  # take away stopwords
  anti_join(stop_words) %>%
  
  # id word counts
  count(id, word, sort = FALSE)


# create total word count across all responses
total_word_count.df <-
  
  df %>%
  
  # break down local_issues into words
  unnest_tokens(output = word, input = text) %>%
  
  # get total count of each word
  group_by(word) %>%  summarise(total = n())


# form final word_count.df before cast to dtm
word_counts.df %<>%
  
  # join total word usage to word count per person
  left_join(total_word_count.df) %>%
  
  # filter out words with total usage >1
  filter(total > 1) %>%
  
  # then drop total column for casting dtm
  select(-c(total))


# Cast to DTM ----------------------------------------------------------------------------

# then cast word_counts.df to a dfm (needs to reference new df)
dtm <- word_counts.df %>%
  cast_dtm(data = ., document = id, term = word, value = n)

rm(total_word_count.df, word_counts.df)
