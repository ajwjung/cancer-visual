import pandas as pd

# Import data
df = pd.read_csv("idh1-brain-mutations.tsv", sep="\t", header=0)

# Extract consequence types involving IDH1 only
consequences = df["Consequences"].str.extractall(r'([A-Z\d]+[\w\s]+)(?=: IDH1)').unstack("match")
consequences = consequences.where(consequences.notnull(), None) # Replace "NaN" with "None"

# Obtain frequencies for each consequence type
cons_freq = consequences.stack().value_counts() # series
freq = cons_freq.rename_axis("Consequences").reset_index(name="Frequency") # dataframe
