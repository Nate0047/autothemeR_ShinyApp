# Person-Topic Classification ------------------------------------------------------------

# assign binary coding across the public_survey_data.df where 1 = dominant topics.


# Assign Binary Coding -------------------------------------------------------------------

# use the highest gamma scores to assign 1 to topics across sample (ties all coded as 1)
binary <- t(apply(
  as.matrix(public_survey_data.df[ , -1:-3]), 1, function(x) as.integer(x == max(x))
))

# append the binary coding to the public_survey_data.df
public_survey_data.df <-
  
  # take binary coding of the max gamma values
  binary %>%
  
  # turn the matrix into a df
  as.data.frame() %>%
  
  # column bind the binary df to the public_survey_data df - remove binary
  cbind(public_survey_data.df, .)

rm(binary)


# Assign NA Coding -----------------------------------------------------------------------

# some cases had NA in gamma fields (likely excluded from LDA during preprocessing)
# assign an additional column to the df to capture non-coded
public_survey_data.df %<>%
  mutate(VNA = case_when(V1 = is.na(V1) ~ 1,
                         TRUE ~ 0))

