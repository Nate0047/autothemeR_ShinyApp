# Environment Setup ----------------------------------------------------------------------

# scientific notation settings:
options(scipen = 999)

# establish custom colour palette for visuals:
cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2",
               "#D55E00", "#CC79A7")


# Packages -------------------------------------------------------------------------------

# set libpath to global package environment:
.libPaths("C:/R library")

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