
library(tidyverse)
library(lubridate)
library(dplyr)
mloa <- read_csv("https://raw.githubusercontent.com/gge-ucd/R-DAVIS/master/data/mauna_loa_met_2001_minute.csv")
View(mloa)

# Use the README file associated with the Mauna Loa dataset to determine in what time zone the data are reported, and how missing values are reported in each column. 

# The data are reported in UTC for date and time (Coordinated Universal Time).
# Wind direction -999
# Wind speed -999.99
# Wind steadiness factor -9
# Barometric Pressure -999.90
# Temperature (at 2 and 10m and Tower Top) -999.9
# Relative Humidity -99
# Precipitation Intensity -99


# With the mloa data.frame, remove observations with missing values in rel_humid, temp_C_2m, and windSpeed_m_s. 

mloa2 <- mloa %>% 
  filter(rel_humid !=-99, temp_C_2m != -999.9, windSpeed_m_s != -99.9)

# Generate a column called “datetime” using the year, month, day, hour24, and min columns. 

mloa2 <- mloa2 %>% mutate(datetime = ymd_hm(paste(year, month, day, hour24, min, sep = '-'))) %>% select(datetime)

head(mloa2)
                 
# Next, create a column called “datetimeLocal” that converts the datetime column to Pacific/Honolulu time (HINT: look at the lubridate function called with_tz()). 

# datetimelocal <- ymd_hm(datetime)

with_tz(mloa2$datetime, "Pacific/Honolulu")


# Then, use dplyr to calculate the mean hourly temperature each month using the temp_C_2m column and the datetime Local columns. (HINT: Look at the lubridate functions called month() and hour()). 

lubridate::month(mloa2$datetime)

#Finally, make a ggplot scatterplot of the mean monthly temperature, with points colored by local hour.
