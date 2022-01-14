# Load packages
library(dbplyr)
library(ggplot2)
library(tidyr)

# Clear all stored variables
rm(list=ls())

# Load data
idh1_data <- read.table(file = 'idh1-brain-mutations.tsv', sep = '\t', header = TRUE)

# Separate all consequences into new columns
idh1_cons <- within(idh1_data, Consequences<-data.frame(do.call('rbind', strsplit(as.character(Consequences), '|', fixed=TRUE))))

# Extract all consequence types
all_consequences <- str_extract_all(idh1_data$Consequences,"(^\\d\\s\\w+|^\\w+)(?=: IDH1)|(\\w+)(?=: IDH1)")

# Obtain frequencies of each consequence
counts <- c()
for (i in all_consequences)
{
  counts <- c(counts, i)
}

slices <- as.data.frame(table(counts, dnn = list("Counts")), responseName = "Freq")

# Create labels for and get percentages of each slice
slices$Percent <- round(100*slices$Freq/sum(slices$Freq), digits=1)
slices$Label <- paste(slices$Counts, " (", slices$Percent, "%)", sep="")

# Generate pie chart
pie(slices$Freq, labels = slices$Label, main="IDH1 SNPs Consequence Types", 
    radius = 0.9, col=terrain.colors(nrow(slices))) # original

pie(slices$Freq, labels = slices$Label, main="IDH1 SNPs Consequence Types", 
    radius = 0.9, init.angle=90, col=terrain.colors(nrow(slices))) # rotated 90 deg

pie(slices$Freq, labels = slices$Label, main="IDH1 SNPs Consequence Types", 
    radius = 0.9, init.angle=115, col=terrain.colors(nrow(slices))) # rotated 110 deg

# Generate bar chart
gg <- ggplot(slices, aes(x = reorder(Counts, -Freq), y = Freq,
                            fill=rownames(slices))) +
  ggtitle("Frequencies of IDH1 Mutation Consequences") +
  xlab("Consequence Type") + ylab("# of Mutations") + 
  geom_bar(stat="identity", show.legend = FALSE) + 
  theme_minimal()

gg

