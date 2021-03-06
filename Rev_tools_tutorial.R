#Learning REVtools -----

#source = https://revtools.net/assets/docs/Westgate_revtools_bioRxiv_v2.pdf
library("revtools")

# 1) first try with causes of corruption in and Web of Sciences---
# search terms: TITLE ( corrupt*  AND  cause* )
# download as ris

#1. import references----
setwd("/Users/anacristinaeguigurenburneo/Google Drive/Sperm Whale culture/PhD/Classes/Cultural_Evolution/Project_Corruption/Causes_Corruption/Download_references")

data_list <- read_bibliography(list.files())#automatically links
setwd("/Users/anacristinaeguigurenburneo/Google Drive/Sperm Whale culture/PhD/Classes/Cultural_Evolution/Project_Corruption/Causes_Corruption")

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


length(unique(title_match)) # n = 150 of 209 - 39% duplicates
data_unique <- extract_unique_references(data, title_match)

# this method found 2 duplicates, 
# its a good idea to try two methods

# Screen references ----
result <- screen_topics(data_unique)

setwd("/Users/anacristinaeguigurenburneo/Google Drive/Sperm Whale culture/PhD/Classes/Cultural_Evolution/Project_Corruption/Causes_Corruption/Causes_corruption_Version_Control")


write_bibliography(data_unique, "Outputs/Unique_Causes_Corruption", format = "ris") 
write.csv(data_unique, "Outputs/Unique_Causes_Corruption.csv")

