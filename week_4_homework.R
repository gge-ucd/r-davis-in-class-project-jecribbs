#1. Keep only observations before 1995
surveys_base <- filter(surveys, year < 1995)

#2. Retain only the columns year, sex, and weight
surveys_base <- select(surveys_base, year, sex, weight)
str(surveys_base)

surveys_base <- select(surveys_base, year, sex, weight) %>% filter(year < 1995)
#tidy
surveys_base <- surveys %>% filter(year<1995) %>% select(year, sex, weight)
#nested
surveys_base <- filter(select(surveys, year, sex, weight), year < 1995)
#order doesn't matter, except if you are dropping columns/data or for speed (e.g. reduce then calculate)

#Mutate--writing a new column or mutating an existing column

#Create a new data frame from the surveys data that meets the following criteria:
#1. contains only the species_id_column (select)

new_surveys <- surveys %>% select(species_id)

#2. and a new column called hindfoot_half containing values that are half the hindfoot

new_surveys$hindfoot_half <- new_surveys %>% mutate(hindfoot_length/2)

#####
surveys$hindfoot_half <- surveys %>% 
  filter(!is.na(hindfoot_length)) %>%
  mutate(hindfoot_half = hindfoot_length/2) %>% 
  select (species_id, hindfoot_half) %>% 
  filter(hindfoot_half < 30)

#### Group By and Summary
?group_by
?summarize
surveys %>% group_by(species_id) %>% filter(!is.na(hindfoot_length)) %>% summarise(mean(hindfoot_length), min(hindfoot_length, max(hindfoot_length)))
 
surveys_hindfoot_half %>% group_by(species_id) %>%
  mutate(hindfoot_length = hindfoot_half *2) %>%
  summarize(ave_length = mean(hindfoot_length), min(hindfoot_length), max(hindfoot_length))
head()