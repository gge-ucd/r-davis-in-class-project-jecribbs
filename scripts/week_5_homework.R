# Homework 5
# Jenny Cribbs

#1. Create a tibble named surveys from the portal_data_joined.csv file. Then manipulate surveys to create a new dataframe called surveys_wide with a column for genus and a column named after every plot type, with each of these columns containing the mean hindfoot length of animals in that plot type and genus. So every row has a genus and then a mean hindfoot length value for every plot type. The dataframe should be sorted by values in the Control plot type column. This question will involve quite a few of the functions you’ve used so far, and it may be useful to sketch out the steps to get to the final result.

library(tidyverse)
surveys <- read_csv('data/portal_data_joined.csv')

surveys_wide <- pivot_wider(surveys, id_cols = genus, names_from = plot_type, values_from = hindfoot_length, values_fn = mean) # this seems to work, but generates a lot of NAs...is this right? 
# I tried piping to sort and adding names_sort as an argument to pivot_wider, but I don't think I understand how to sort these results %>% sort(surveys_wide$Control)  

# suggested answer
surveys_wide <- surveys %>% 
  filter(!is.na(hindfoot_length)) %>% # removing the NAs for hindfoot length 
  group_by(genus, plot_type) %>% 
  summarise(mean_hindfoot = mean(hindfoot_length)) %>% # Is this the same as values_from = hindfoot_length, values_fn = mean or does the latter not really work?
  pivot_wider(names_from = plot_type, values_from = mean_hindfoot) %>% 
  arrange(Control) # arrange sorts by the Control column

#2. Using the original surveys dataframe, use the two different functions we laid out for conditional statements, ifelse() and case_when(), to calculate a new weight category variable called weight_cat. For this variable, define the rodent weight into three categories, where “small” is less than or equal to the 1st quartile of weight distribution, “medium” is between (but not inclusive) the 1st and 3rd quartile, and “large” is any weight greater than or equal to the 3rd quartile. (Hint: the summary() function on a column summarizes the distribution). For ifelse() and case_when(), compare what happens to the weight values of NA, depending on how you specify your arguments.

# use summary to find the quartiles
summary(surveys$weight)

# calculate a new weight category variable using ifelse()
surveys_ifelse <- na.omit(surveys) %>% mutate(weight_cat = ifelse(weight <= 20.00, "small", ifelse(weight > 48.00, "large", "medium")))

# calculate a new weight category variable using case_when()
surveys_casewhen <- surveys %>% mutate(weight_cat = case_when(weight <= 20.00 ~ "small", weight > 20.00 & weight < 48.00 ~ "medium", weight >= 48.00 ~ "large"))

# The case when version retains all 34,786 records from the original surveys dataframe, including all NA values for weight and all other variables. The new column weight_cat also displays NAs when the orignal weight was NA. In the ifelse version above, I used na.omit to remove all the NAs prior to creating the new weight category column. In this version, there are only 30,676 rows because all rows with weight NA have been eliminated. 

# Adding an additional case for when weight is NA allows the addition of a custom "no weight" category rather than the default NA
surveys_casewhen <- surveys %>% mutate(weight_cat = case_when(weight <= 20.00 ~ "small", weight > 20.00 & weight < 48.00 ~ "medium", weight >= 48.00 ~ "large", is.na(weight) ~ "no weight"))

# BONUS: How might you soft code the values (i.e. not type them in manually) of the 1st and 3rd quartile into your conditional statements in question 2? 

# returns the first quantile value (2nd element of the summary)
summary(surveys$weight)[2] # returns 1st Qu. 20
# returns the third quantile value (5th element of the summary)
summary(surveys$weight)[[5]] # returns only the number 48

# using indexing as shown above to soft code the first and third quantiles
surveys_ifelse_softcode <- na.omit(surveys) %>% mutate(weight_cat = ifelse(weight <= summary(surveys$weight)[[2]], "small", ifelse(weight > summary(surveys$weight)[[5]], "large", "medium")))

# saving summary results as weight summary to make all the cases less ugly
weight_summary <- summary(surveys$weight)
# using indexing on the weight summary object
surveys_casewhen_softcode <- surveys %>% mutate(weight_cat = case_when(weight <= weight_summary[[2]] ~ "small", weight > weight_summary[[2]] & weight < weight_summary[[5]] ~ "medium", weight >= weight_summary[[5]] ~ "large", is.na(weight) ~ "no weight"))

# double check with identical to make sure the hard code and soft code results are the same
identical(surveys_casewhen, surveys_casewhen_softcode) # TRUE
identical(surveys_ifelse, surveys_ifelse_softcode) # TRUE
# This checked out with single brackets too, but it seems better to extract the numeric values only from the summary table. 

########
library(tidyverse)
surveys <- read_csv("data/portal_data_joined.csv")

# EXPLORING the NA situation with conditional statements
## leaving the last "else" argument in case_when assigns the 'large' value to EVERYTHING else, including NAs

surveys %>%
  mutate(weight_cat = case_when(
    weight >= 20.00 ~ "small",
    weight > 20.00 & weight < 48.00 ~ "medium",
    T ~ "large"
  )) %>%
  select(weight, weight_cat) %>%
  filter(is.na(weight))


# leaving the last "else" argument in ifelse assigns the 'large' value to everything else, BUT DOES NOT INCLUDE NAs
surveys %>%
  mutate(weight_cat = ifelse(weight >= 20.00, "small",
                             ifelse(weight > 20.00 & weight < 48.00, "medium"
                                    ,"large"))) %>%
  select(weight, weight_cat) %>%
  filter(is.na(weight))

# specify the final argument in case_when()
surveys %>%
  mutate(weight_cat = case_when(
    weight >= 20.00 ~ "small",
    weight > 20.00 & weight < 48.00 ~ "medium",
    weight >= 48.00 ~ "large"
  )) %>%
  select(weight, weight_cat) %>%
  filter(is.na(weight))

# Manipulate surveys to create a new dataframe called surveys_wide with:
# 1. column for genus and a column named after every plot type (step 2)
# 2. each of these columns containing the mean hindfoot length of animals in that plot type and genus. So every row has a genus and then a mean hindfoot length value for every plot type. (step 1)
# 3. The dataframe should be sorted by values in the Control plot type column. (step 3)

# Step 1:
surveys2 <- surveys %>%
  filter(!is.na(hindfoot_length)) %>%
  group_by(plot_type, genus) %>%
  summarize(mean_hindfoot = mean(hindfoot_length))
surveys2

# Step 2 & 3:
surveys_wide <- pivot_wider(surveys2, names_from = "plot_type", values_from = "mean_hindfoot")
surveys_wide

surveys_wide %>% 
  arrange(desc(Control))

surveys_wide

# What if we wanted to reverse this back into the longer version of what we made before
?pivot_longer
surveys_reverse <- surveys_wide %>%
  pivot_longer(cols = c(Control:`Spectab exclosure`),
               names_to = "plot_type",
               values_to = "mean_hindfoot")
# cols:  which columns I want to pivot
# names_to: takes the column name and puts them into a column. What do you want to name the column of column names?
# values_to: takes the values from each of these columns cells. What do you want to name the column of cell values?