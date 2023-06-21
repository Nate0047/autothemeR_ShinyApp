# Visualise LDA Results ------------------------------------------------------------------

# LDAvis package will feed model via JSON into an interactive javascript visual for interpretation

# establish criteria to read into createJSON function
# package CRAN page: https://cran.r-project.org/web/packages/LDAvis/index.html

# issue with getting topic orders when extracting phi and theta - answer here on stack overflow: 
# https://stackoverflow.com/questions/64212479/can-i-manually-reorder-a-lda-gibbs-topicmodel

# get poterior from fitted lda model
lda_posterior <- posterior(local_issues.lda)

# use posterior to create each of the elements for json object
# need phi, theta, doc.length, vocab and term frequency
public_survey_data.dtm = public_survey_data.dtm[slam::row_sums(public_survey_data.dtm) > 0, ]

phi <- as.matrix(lda_posterior$terms)
theta <- as.matrix(lda_posterior$topics)
vocab <- colnames(phi)
doc.length = slam::row_sums(public_survey_data.dtm)
term.freq = slam::col_sums(public_survey_data.dtm)[match(vocab, colnames(public_survey_data.dtm))]

# build the elements into the json object
json = createJSON(phi = phi, 
                  theta = theta, 
                  vocab = vocab, 
                  doc.length = doc.length, 
                  term.frequency = term.freq)

# feed the json object into the package to get javascript visual
serVis(json)
