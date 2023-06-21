# Build Topic Model ----------------------------------------------------------------------

# building topic modelling through LDA

# build lda model with k topics - begin with 4 and change to see what fits best against
# random sample of data (see end of script)
local_issues.lda <- topicmodels::LDA(x = public_survey_data.dtm, 
                                     k = 10,
                                     method = "Gibbs",
                                     control = list(seed = 47, alpha = 0.1))

# tidy lda output to tibble
local_issues_beta.tbl <- tidy(local_issues.lda, matrix = "beta")


# Interpret Topics -----------------------------------------------------------------------

# top terms in each topic - build visual
local_issues_beta.tbl %>%
  group_by(topic) %>%
  slice_max(beta, n = 15) %>%
  ungroup() %>%
  arrange(topic, -beta) %>%
  mutate(term = reorder_within(term, beta, topic)) %>%
ggplot(., aes(x = beta, y = term, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free_y") +
  scale_y_reordered()


# Assign Topics --------------------------------------------------------------------------

# assign per-person topic classification
person_gamma.tbl <- tidy(local_issues.lda, matrix = "gamma")

# reshape gamma data to wide (topic per col with topic weight assigned)
person_gamma.tbl %<>%
  pivot_wider(id_cols = document, names_from = topic, values_from = gamma)

# join to original df
public_survey_data.df %<>%
  mutate(id = as.character(id)) %>%
  left_join(., person_gamma.tbl, by = c("id" = "document"))


# Assess Fit -----------------------------------------------------------------------------

# to identify the best fit of the topics back to the raw comments, take random sample and
# manually review performance
set.seed(47)
random_ids <- floor(runif(100, min = 1, max = 4203))

# generate random sample
random_sample.df <-
  
  public_survey_data.df %>%
  
  # filter id based on random numbers generated 
  filter(id %in% random_ids)

random_sample.df # 5 topics seems to best classify responses

rm(random_ids, random_sample.df)

