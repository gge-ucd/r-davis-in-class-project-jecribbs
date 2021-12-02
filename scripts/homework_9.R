# Homework 9

# I thought I completed most of this in class, but when I tried to finish the last two steps, I discovered something is still wrong with my date formats. I can't do the necessary calculations using month() and hour() because R does not recognize the format. I tried a few things from Stack Overflow, but they didn't help. I think something is wrong with the second step, but it looks identical to the example to me. I changed paste to past 0, changed to the exact separators that the example uses, and added the time zone, but it still gives the same error. I tried piping to the next step too like the example, but that also failed to make a difference. 

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
head(mloa2)

# Generate a column called “datetime” using the year, month, day, hour24, and min columns. (I had to revise this based on the answer key because I didn't specify the UTC timezone and didn't specify the separators correctly. However, now it doesn't recognize hour24, though this looks identical to me. 

mutate(datetime = ymd_hm(paste0(year,"-", month,"-", day," ", hour24, ":", min), tz = "UTC"))
             
# Next, create a column called “datetimeLocal” that converts the datetime column to Pacific/Honolulu time (HINT: look at the lubridate function called with_tz()). 

mutate(datetimeLocal = with_tz(mloa2$datetime, "Pacific/Honolulu"))
head(mloa2$datetimeLocal)

# Then, use dplyr to calculate the mean hourly temperature each month using the temp_C_2m column and the datetime Local columns. (HINT: Look at the lubridate functions called month() and hour()). 

#Got stuck here and tried the format function from Stack Overflow
#month(mloa2$datetimeLocal) # Error: Error in as.POSIXlt.default(x, tz = tz(x)) : do not know how to convert 'x' to class “POSIXlt”
#format(as.Date(mloa2$datetimeLocal, format = "%Y-%m-%d"), "%m")

# Eventually copied this from the answers to move on to plotting, but I'm still getting the same error: Error: Problem with `mutate()` column `localMon`.ℹ `localMon = month(datetimeLocal, label = TRUE)`.x do not know how to convert 'x' to class “POSIXlt” mloa2 %>%

  # Extract month and hour from local time column
  mutate(localMon = month(datetimeLocal, label = TRUE),
         localHour = hour(datetimeLocal)) %>%
  # Group by local month and hour
  group_by(localMon, localHour) %>%
  # Calculate mean temperature
  summarize(meantemp = mean(temp_C_2m))

#Finally, make a ggplot scatterplot of the mean monthly temperature, with points colored by local hour.
# Still can't do this part because I'm still missing something with the date formatting. 

# I did verify that the example answer runs, so it's probably not forgetting to install a package or something of that nature.   
  library(tidyverse)
  library(lubridate)
  ## Data import
  mloa <- read_csv("https://raw.githubusercontent.com/gge-ucd/R-DAVIS/master/data/mauna_loa_met_2001_minute.csv")
  
  mloa2 = mloa %>%
    # Remove NA's
    filter(rel_humid != -99) %>%
    filter(temp_C_2m != -999.9) %>%
    filter(windSpeed_m_s != -999.9) %>%
    # Create datetime column (README indicates time is in UTC)
    mutate(datetime = ymd_hm(paste0(year,"-", 
                                    month, "-", 
                                    day," ", 
                                    hour24, ":", 
                                    min), 
                             tz = "UTC")) %>%
    # Convert to local time
    mutate(datetimeLocal = with_tz(datetime, tz = "Pacific/Honolulu"))
  
  ## Aggregate and plot
  mloa2 %>%
    # Extract month and hour from local time column
    mutate(localMon = month(datetimeLocal, label = TRUE),
           localHour = hour(datetimeLocal)) %>%
    # Group by local month and hour
    group_by(localMon, localHour) %>%
    # Calculate mean temperature
    summarize(meantemp = mean(temp_C_2m)) %>%
    # Plot
    ggplot(aes(x = localMon,
               y = meantemp)) +
    # Color points by local hour
    geom_point(aes(col = localHour)) +
    # Use a nice color ramp
    scale_color_viridis_c() +
    # Label axes, add a theme
    xlab("Month") +
    ylab("Mean temperature (degrees C)") +
    theme_classic()
