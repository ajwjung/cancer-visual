# Load packages
library(dbplyr)
library(ggplot2)
library(tidyr)
library(stringr)

# Clear all stored variables
rm(list=ls())

# Load data
idh1_data <- read.table(file = 'idh1-brain-mutations.tsv', sep = '\t', header = TRUE)

# Separate all consequences into new columns
idh1_cons <- within(idh1_data, Consequences<-data.frame(do.call('rbind', strsplit(as.character(Consequences), '|', fixed=TRUE))))

# Count the number of each consequences
consequences <- idh1_cons[,4]

# Extract all consequence types
all_consequences <- str_extract_all(idh1_data$Consequences,"(^\\d\\s\\w+|^\\w+)(?=: IDH1)|(\\w+)(?=: IDH1)")
all_consequences

# Count total num of occurrences of each consequence
counts <- c()
for (i in all_consequences)
{
  counts <- c(counts, i)
}

counts
slices <- as.data.frame(table(counts))
slices
