# Data Formatting ------------------------------------------------------------------------

# tidytext to preprocess then cast to dtm for lda analysis


# Preprocessing --------------------------------------------------------------------------

# tidytext preprocessing to create count of words per person
word_counts.df <-
  
  public_survey_data.df %>%
  
  # break down local_issues text into words
  unnest_tokens(output = word, input = local_issues) %>%
  
  # take away stopwords
  anti_join(stop_words) %>%
  
  # id word counts
  count(id, word, sort = FALSE)


# create total word count across all responses
total_word_count.df <-
  
  public_survey_data.df %>%
  
  # break down local_issues into words
  unnest_tokens(output = word, input = local_issues) %>%
  
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
public_survey_data.dtm <- word_counts.df %>%
  cast_dtm(data = ., document = id, term = word, value = n)

rm(total_word_count.df, word_counts.df)