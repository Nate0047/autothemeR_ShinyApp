# LDA on Police Data ---------------------------------------------------------------------

# script to run LDA on police survey data


# Environment Setup ----------------------------------------------------------------------
source("environment.r")


# Import Data ----------------------------------------------------------------------------

# import data from .xls file
public_survey_data.df <-
  read_excel("data/Lancashire PCC Crime & Confidence Survey 2020 (4611).xls") %>%
  janitor::clean_names() %>%
  select(id, q6, q10) %>%
  rename(local_issues = q6, postcode = q10) %>%
  na.omit()


# Data Formatting ------------------------------------------------------------------------
source("data formatting.r")


# Conduct LDA Modelling ------------------------------------------------------------------
source("topic modelling.r")


# Person-Topic Classification ------------------------------------------------------------
source("person-topic classification.r")


# Review ---------------------------------------------------------------------------------
public_survey_data.df %>%
  filter(V1 == 1) %>%
  View()
# best fit resulted from:
# - keeping as many words as possible in preprocessing
# - build pipeline to binary code topics against raw text
# - work backwards from high k to see when topics appear concise, but also do well in classifying the raw text.


# Visualise using LDAvis package ---------------------------------------------------------
source("visualise lda results.r")
