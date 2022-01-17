# Load packages
library(dplyr)
library(stringr)
library(ggplot2)
library(tidyr)

# Clear all stored variables
rm(list=ls())

# Load data
idh1_data <- read.table(file = 'idh1-brain-mutations.tsv', sep = '\t', header = TRUE)

# Extract all consequence types
all_consequences <- idh1_data$Consequences %>%
  str_extract_all("(^\\d\\s\\w+|^\\w+)(?=: IDH1)|(\\w+)(?=: IDH1)")

# Obtain frequencies of each consequence
cons_freq <- data.frame(table(unlist(all_consequences))) %>%
  rename(Consequence = Var1)

# Generate pie chart
# Create columns for percentages and labels (pie chart)
cons_freq$Percent <- round(100*cons_freq$Freq/sum(cons_freq$Freq), digits=1)
cons_freq$Label <- paste(cons_freq$Consequence, " (", cons_freq$Percent, "%)", sep="")

pie(cons_freq$Freq, labels = cons_freq$Label,
    main="IDH1 SNPs Consequence Types", 
    radius = 0.9, col=terrain.colors(nrow(cons_freq))) # original

pie(cons_freq$Freq, labels = cons_freq$Label,
    main="IDH1 SNPs Consequence Types", 
    radius = 0.9, init.angle=90,
    col=terrain.colors(nrow(cons_freq))) # rotated 90 deg

pie(cons_freq$Freq, labels = cons_freq$Label,
    main="IDH1 SNPs Consequence Types", 
    radius = 0.9, init.angle=115,
    col=terrain.colors(nrow(cons_freq))) # rotated 110 deg

# Generate bar chart
gg <- ggplot(cons_freq, aes(x = reorder(Consequence, -Freq), y = Freq,
                            fill=rownames(cons_freq))) +
  ggtitle("Types of IDH1 Mutations") +
  xlab("Consequence Type") + ylab("# of Mutations") + 
  geom_bar(stat="identity", show.legend = FALSE) +
  geom_text(aes(label=Freq), position=position_dodge(width=0.9), vjust=-0.25) + 
  theme_minimal()

gg

