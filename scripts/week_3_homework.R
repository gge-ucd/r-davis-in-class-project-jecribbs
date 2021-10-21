
# Homework 3
# Jenny Cribbs

#Load your survey data frame with the read.csv() function. Create a new data frame called surveys_base with only the species_id, the weight, and the plot_type columns. Have this data frame only be the first 60 rows. Convert both species_id and plot_type to factors. Explore these variables and try to explain why a factor is different from a character. Remove all rows where there is an NA in the weight column.

#load packages
install.packages("tidyverse")
library(tidyverse)
surveys <- read.csv("data/portal_data_joined.csv") #read in data
surveys_base <- select(surveys, species_id, weight, plot_type) #requires tidyverse
surveys_base <- surveys[c('species_id', 'weight', 'plot_type')] #base R way
surveys_base <- surveys %>% select(species_id, weight, plot_type)
surveys_base <- head(surveys_base, 60)

surveys_base <- surveys[c(1:60), c(6,9,13)]
surveys_base <- head(surveys[c(6,9,13)], n = 60)
surveys_base <- surveys[1:60, c('species_id', 'weight', 'plot_type')] 

as.factor(surveys$species_id)
as.factor(surveys$plot_type)
surveys_base$species_id <- as.factor(surveys_base$species_id)

surveys_base_nonas <- na.omit(surveys_base) #removes nas from the whole df
surveys_base_nonas <- na.omit(surveys_base$weight) #feed in the weight vector get a vector out

is.na(surveys_base$weight) #generates a vector of T/F
!is.na(surveys_base$weight) #false for nas, true for data
str(surveys_base_nonas)

surveys_base[!is.na(surveys_base$weight), ]
surveys_base %>% na.omit(surveys_base$weight)

complete.cases(surveys_base)

#CHALLENGE: Create a second data frame called challenge_base that only consists of individuals from your surveys_base data frame with weights greater than 150g.

challenge_base <- surveys_base[ , 'weight' > 150,]
challenge_base

challenge_base <- surveys_base[which(surveys_base$weight > 150),]
