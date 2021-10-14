
# Homework 3
# Jenny Cribbs

Load your survey data frame with the read.csv() function. Create a new data frame called surveys_base with only the species_id, the weight, and the plot_type columns. Have this data frame only be the first 60 rows. Convert both species_id and plot_type to factors. Explore these variables and try to explain why a factor is different from a character. Remove all rows where there is an NA in the weight column.

CHALLENGE: Create a second data frame called challenge_base that only consists of individuals from your surveys_base data frame with weights greater than 150g.
surveys <- read.csv("data/portal_data_joined.csv") #read in data