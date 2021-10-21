surveys <- read.csv("data/portal_data_joined.csv") #read in data

head(surveys) #check out the first few records

str(surveys)

#class is a data frame
#13 variables/columns 34,786 rows/observations
# All character type (chr), consistentcy makes the data more workable
# characters are the same as strings
# How many species are represented?
#subsetting from a data frame 2 dimensions
surveys[1,2] # row 1 and column 2

unique(surveys$species) #returns 40 species in a list in the console
length(unique(surveys$species)) #returns 40
table(surveys$species) #gives unique species and their counts
# reverse unique, so something that is not duplicated, then sum it
sum(!duplicated(surveys$species)) # also retuns 40

levels(surveys$species) #can look at unique values only if species is a factor 
#Better to leave things as numbers and characters (easier to change things into a factor to a character, rather thn the other way around)
# as.factor and factor to convert
# For cats

# Converting to a factor
?factor()

species_factor <- factor(surveys$species)
typeof(species_factor) # integer
class(species_factor) # factor
levels(species_factor) # now levels works

#We are going to create a few new data frames using our subsetting skills.

#Create a new data frame called surveys_200 containing row 200 of the surveys dataset.

surveys_200 <- surveys[200,] # no argument after comma means all columns

#Create a new data frame called surveys_last, which extracts only the last row in of surveys.

surveys_last <- surveys[34786,]
surveys_last <- surveys[nrow(surveys),]

#Hint: Remember that nrow() gives you the number of rows in a data frame
#Compare your surveys_last data frame with what you see as the last row using tail() with the surveys data frame to make sure it’s meeting expectations.

#Use nrow() to identify the row that is in the middle of surveys. Subset this row and store it in a new data frame called surveys_middle.
nrow(surveys)/2


surveys_middle <- surveys[nrow(surveys)/2,]

#Reproduce the output of the head() function by using the - notation (e.g. removal) and the nrow() function, keeping just the first through 6th rows of the surveys dataset.

surveys[-(7:nrow(surveys)),]


