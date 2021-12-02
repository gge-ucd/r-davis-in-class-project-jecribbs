# Homework 4
# Jenny Cribbs

library(tidyverse)

# 1. Create a tibble named surveys
# read in surveys
surveys <- read.csv('data/portal_data_joined.csv')
# make surveys into a tibble
surveys <- tibble(surveys)

# or simply
surveys <- read_csv("data/portal_data_joined.csv")

# 2. Subset surveys to keep rows with weight between 30 and 60, and print out the first 6 rows.
head(filter(surveys, weight > 30 & weight < 60))

# cmd + shift + m (shortcut for a pipe)
surveys %>% filter(weight > 30 & weight < 60) %>% head(n = 300, 13)
# can use View() to take a look or colnames()

# 3. Create a new tibble showing the maximum weight for each species + sex combination and name it biggest_critters. Sort the tibble to take a look at the biggest and smallest species + sex combinations. HINT: it’s easier to calculate max if there are no NAs in the dataframe…

biggest_critters <- na.omit(surveys) %>% group_by(species_id, sex) %>% summarise(max(weight, na.rm = TRUE))

biggest_critters <- surveys %>% filter(!is.na(weight) & !is.na(sex) & !is.na(species)) %>% group_by(species, sex) %>% summarize(maximum_weight = max(weight))
biggest_critters

# 4. Try to figure out where the NA weights are concentrated in the data- is there a particular species, taxa, plot, or whatever, where there are lots of NA values? There isn’t necessarily a right or wrong answer here, but manipulate surveys a few different ways to explore this. Maybe use tally and arrange here.
is.na(surveys)
# The NAs seem to be concentrated in the variables weight and hindfoot_length. They are nearly all in the first 40 rows and are most common in the species NL.
arrange(surveys, by_group = TRUE)

surveys %>% 
  filter(is.na(hindfoot_length)) %>% # get all of the NAs in hindfoot
  group_by(species) %>%
  tally() # tally is a dead end

# same as n function, can call additional functions
surveys %>% 
  filter(is.na(hindfoot_length)) %>% # get all of the NAs in hindfoot
  group_by(species) %>%
  summarize(count = n(), mean = mean(weight, na.rm = T))

# sum
sum(is.na(surveys$weight))
colSums(is.na(surveys)) # shows NAs are in sex, hindfoot_length, and weight

# 5. Take surveys, remove the rows where weight is NA and add a column that contains the average weight of each species+sex combination to the full surveys dataframe. Then get rid of all the columns except for species, sex, weight, and your new average weight column. Save this tibble as surveys_avg_weight.

surveys_avg_weight <- surveys %>% filter(weight != "NA") %>% group_by(species_id, sex) %>% summarise(mean(weight)) # I thought this was right until I got to part 6 and realized I had no weight column left to compare the averages too.

# This version uses mutate to name and add an average weight column instead of relying what summarize generated
surveys_avg_weight <- surveys %>% filter(weight != "NA") %>% group_by(species_id, sex) %>% mutate(avg_weight = mean(weight)) %>% select(species_id, sex, weight, avg_weight)

#6. Take surveys_avg_weight and add a new column called above_average that contains logical values stating whether or not a row’s weight is above average for its species+sex combination (recall the new column we made for this tibble).
surveys_avg_weight <- surveys_avg_weight %>% mutate(above_average = weight > avg_weight)

# Conditional statements
# For example divide a continuous variable into bins
# if else or case_when (tidyverse)

surveys %>% 
  filter(!is.na(weight)) %>% # get rid of NAs
  mutate(weight_cat = case_when(weight > mean(weight) ~ "big", weight < mean(weight) ~ "small")) %>% 
  select (weight, weight_cat) %>% 
  tail()

#Using the iris data frame (this is built in to R), create a new variable that categorizes petal length into three groups:

#small (less than or equal to the 1st quartile)
#medium (between the 1st and 3rd quartiles)
#large (greater than or equal to the 3rd quartile)
#Hint: Explore the iris data using summary(iris$Petal.Length), to see the petal length distribution. Then use your function of choice: ifelse() or case_when() to make a new variable named petal.length.cat based on the conditions listed above. Note that in the iris data frame there are no NAs, so we don’t have to deal with them here.

data(iris)
summary(iris)
iris_cat <- iris %>% mutate(petal.length.cat = case_when(Petal.Length <= 1.6 ~ "small", Petal.Length > 1.6 & Petal.Length < 5.1 ~ "medium", Petal.Length >= 5.1 ~ "large"))

# if else
iris %>% 
  mutate(length_cat = ifelse(Petal.Length <= 1.6, "small", ifelse(Petal.Length <= 5.1, "large", "medium")))
# if the first statement is true, small then go to nested. if nested is true go to large and if still not true go to medium

# Joining Data Frames
tail <- read_csv("data/tail_length.csv")
dim(tail)
dim(surveys)
colnames(tail)
colnames(surveys)
summary(surveys$record_id)
summary(tail$record_id)
intersect(colnames(surveys), colnames(tail)) # creates a vector of column names for each and returns record_id for both
combo_dataframe = left_join(surveys, tail)
str(combo_dataframe)

# Pivot can change a wide data frame to long and vice versa
# Sometimes requires some trial and error 
?pivot_wider
temp_df %>% ungroup() # clears previous groupings
temp_df <- surveys %>% group_by(year, plot_id) %>%  tally()
pivot_wider(temp_df, names_from = 'year', values_from = 'n')

surveys %>% group_by(plot_id, year) %>%  summarize(n_distinct(genus))
surveys %>% group_by(plot_id, year) %>%  summarize(distinct_genus = n_distinct(genus))
surveys %>% group_by(plot_id, year) %>%  summarize(length(unique(genus)))

                                                   