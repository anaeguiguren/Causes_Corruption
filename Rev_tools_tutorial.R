#Learning REVtools -----
#source = https://revtools.net/assets/docs/Westgate_revtools_bioRxiv_v2.pdf
library("revtools")

# 1) first try with causes of corruption in scopus---
# search terms: TITLE ( corrupt*  AND  cause* )
# download as ris

#1. import references----
data_list <- read_bibliography("Download_references/scopus_causes_corruption.ris")#automatically links

head(data_list)
names(data_list)

#retain only columns that have data in them
keep_cols <- which(
  apply(data_list, 2, function(a){
    length(which(!is.na(a)))
  })>10# choose a small enough number that it won't remove
  #most of your records
)

data <- data_list[, keep_cols]
head(data)
#2. eliminate duplicates----
#find which columns are duplicates
doi_match <- find_duplicates(data,
              match_variable = "doi",
              group_variables = NULL,
              match_function = "exact")


# an alternative is to try fuzzy title matching 
title_match <- find_duplicates(data,
                    match_variable = "title", 
                    group_variables = NULL, 
                    match_function = "stringdist", 
                    method = "osa",
                    threshold = 5 )


length(unique(title_match)) # n = 103 - 1.91% duplicates
data_unique <- extract_unique_references(data, title_match)

# this method found 2 duplicates, 
# its a good idea to try two methods

# Screen references ----
result <- screen_topics(data_unique)

