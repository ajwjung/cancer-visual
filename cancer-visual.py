import pandas as pd
import matplotlib.pyplot as plt

# Import data
df = pd.read_csv("idh1-brain-mutations.tsv", sep="\t", header=0)

# Extract consequence types involving IDH1 only
consequences = df["Consequences"].str.extractall(r'([A-Z\d]+[\w\s]+)(?=: IDH1)').unstack("match")
consequences = consequences.where(consequences.notnull(), None) # Replace "NaN" with "None"

# Obtain frequencies for each consequence type
cons_freq = consequences.stack().value_counts() # series
freq = cons_freq.rename_axis("Consequences").reset_index(name="Frequency") # dataframe

# Create a bar plot
fig, ax = plt.subplots()
ax.bar(freq["Consequences"], freq["Frequency"])
ax.set_xlabel("Consequence Type")
ax.set_ylabel("# of Mutations")
ax.set_title("Frequencies of IDH1 Mutation Consequences")
ax.tick_params(axis='both', which='major', labelsize=8) # resize labels
plt.setp(ax.get_xticklabels(), rotation=30, horizontalalignment='right') # rotate x-labels

plt.show()