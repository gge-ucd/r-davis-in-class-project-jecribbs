# Homework 4
# Jenny Cribbs

library(tidyverse)

# 1. Create a tibble named surveys
# read in surveys
surveys <- read.csv('data/portal_data_joined.csv')
# make surveys into a tibble
surveys <- tibble(surveys)

# 2. Subset surveys to keep rows with weight between 30 and 60, and print out the first 6 rows.
head(filter(surveys, weight > 30 & weight < 60))

# 3. Create a new tibble showing the maximum weight for each species + sex combination and name it biggest_critters. Sort the tibble to take a look at the biggest and smallest species + sex combinations. HINT: it’s easier to calculate max if there are no NAs in the dataframe…

biggest_critters <- na.omit(surveys) %>% group_by(species_id, sex) %>% summarise(max(weight, na.rm = TRUE))

# 4. Try to figure out where the NA weights are concentrated in the data- is there a particular species, taxa, plot, or whatever, where there are lots of NA values? There isn’t necessarily a right or wrong answer here, but manipulate surveys a few different ways to explore this. Maybe use tally and arrange here.
is.na(surveys)
# The NAs seem to be concentrated in the variables weight and hindfoot_length. They are nearly all in the first 40 rows and are most common in the species NL.
arrange(surveys, by_group = TRUE)

# 5. Take surveys, remove the rows where weight is NA and add a column that contains the average weight of each species+sex combination to the full surveys dataframe. Then get rid of all the columns except for species, sex, weight, and your new average weight column. Save this tibble as surveys_avg_weight.

surveys_avg_weight <- surveys %>% filter(weight != "NA") %>% group_by(species_id, sex) %>% summarise(mean(weight)) # I thought this was right until I got to part 6 and realized I had no weight column left to compare the averages too.

# This version uses mutate to name and add an average weight column instead of relying what summarize generated
surveys_avg_weight <- surveys %>% filter(weight != "NA") %>% group_by(species_id, sex) %>% mutate(avg_weight = mean(weight)) %>% select(species_id, sex, weight, avg_weight)

#6. Take surveys_avg_weight and add a new column called above_average that contains logical values stating whether or not a row’s weight is above average for its species+sex combination (recall the new column we made for this tibble).
surveys_avg_weight <- surveys_avg_weight %>% mutate(above_average = weight > avg_weight)
