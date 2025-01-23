# Load necessary libraries
library(sparklyr)
library(DBI)
library(dplyr)
library(data.table)
library(readr)
library(stringr)
library(lubridate)



df <- fread("0001698-250121130708018.csv")  

# Rename the col
setnames(df, "eventDate", "date")

# data subset just to keep important variable 
important_columns <- c("scientificName","occurrenceID", "verbatimScientificName", "kingdom", "phylum", "class", "order", 
                       "family", "genus", "species", "infraspecificEpithet", "taxonRank", "date", 
                       "countryCode", "locality", "stateProvince", "decimalLatitude", 
                       "decimalLongitude", "individualCount", "taxonKey", "speciesKey")

# Keep only the important columns
df <- df[, ..important_columns]

# Remove author names from the scientific name (if any)
df[, vernacularName := sub(" \\(.*\\)$", "", scientificName)]

# Extract the species epithet (the second part of the scientific name)
df[, vernacularName := sub("^([A-Z][a-z]+) ([a-z]+).*$", "\\2", vernacularName)]

# Save file
fwrite(df, "preprocessed_dataset.csv") 