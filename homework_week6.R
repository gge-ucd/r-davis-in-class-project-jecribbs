# Homework 6

library(tidyverse)

gapminder <- read_csv("https://gge-ucd.github.io/R-DAVIS/data/gapminder.csv")

# 1. First calculate mean life expectancy on each continent. Then create a plot that shows how life expectancy has changed over time in each continent. Try to do this all in one step using pipes! (aka, try not to create intermediate dataframes)

gapminder %>% group_by(continent) %>% summarize(mean(lifeExp))


ggplot(gapminder,
    aes(x = year, y = lifeExp)) +
    geom_point(aes(color = continent), size = 0.3) +
    theme_classic()

# 2. Look at the following code and answer the following questions. What do you think the scale_x_log10() line of code is achieving? What about the geom_smooth() line of code?

ggplot(gapminder, aes(x = gdpPercap, y = lifeExp)) +
  geom_point(aes(color = continent), size = gapminder$pop/max(gapminder$pop)) +  # scaling the size of the points relative to the largest population
  scale_x_log10() +   # taking log base 10 of the percapita gdp / displaying gdp on a log scale
  geom_smooth(method = 'lm', color = 'black', linetype = 'dashed') + # geom smooth is creating a linear model and displaying it as a black dashed line
  theme_bw()


# 3. Create a boxplot that shows the life expectency for Brazil, China, El Salvador, Niger, and the United States, with the data points in the backgroud using geom_jitter. Label the X and Y axis with “Country” and “Life Expectancy” and title the plot “Life Expectancy of Five Countries”.

gapminder %>%
  filter(country == "Brazil" | country == "China" | country == "El Salvador" | country == "Niger" | country == "United States") %>%
  ggplot(mapping = aes(x = country, y = lifeExp)) +
  geom_boxplot(alpha = 0.1) +
  geom_jitter(alpha = 0.3, mapping = aes(color = continent)) +
  labs(x = "Country",  
       y = "Life Expectancy", 
       title = "Life Expectancy of Five Countries",  
       color = "Continent") + 
  theme_classic() 
