# Build Topic Model ----------------------------------------------------------------------

# building topic modelling through LDA
lda <- topicmodels::LDA(x = dtm,
                        k = 10, 
                        method = "Gibbs", 
                        control = list(seed = 47, alpha = 0.1))



