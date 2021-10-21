# Weeks 1-4 Review
elephant1_kg <- 3492
elephant2_lb <- 7757

# convert to kg
elephant2_kg <-elephant2_lb * 2.2
# test whether elephant1 is heavier than elephant2
elephant1_kg > elephant2_kg # returns false

# check working directory
getwd()

# How R thinks about data

num_char <- c(1, 2, 3, "a")
class(num_char) # class is character even though first 3 are numbers

num_logical <- c(1, 2, 3, TRUE)  
class(num_logical) # class is numeric

char_logical <- c("a", "b", "c", TRUE)
class(char_logical) # class is character

tricky <- c(1, 2, 3, "4")
class(tricky) # class is character because 4 was input as a character ""

num_logical <- c(1, 2, 3, TRUE)
class(num_logical) # TRUE get coerced to 1
num_logical
char_logical <- c("a", "b", "c", TRUE)
class(char_logical)
char_logical # TRUE gets coerced to character
combined_logical <- c(num_logical, char_logical)
combined_logical # only 1 instance of true as a character
# logical --> numeric (1 or 0) or character
# numeric --> character

animals <- c("mouse", "rat", "dog", "cat")
animals[2] # could be read as "return the second value in animals"
animals[c(3,2)]

animals <- c("mouse", "rat", "dog", "cat")
animals[animals == "cat" | animals == "rat"] # returns both rat and cat
animals %in% c("rat", "cat", "dog", "duck", "goat")
animals[animals %in% c("rat", "cat", "dog", "duck", "goat")]

"four" > "five" # returns TRUE
"three" < "five"
"five" == "five"

# Removing NAs
heights <- c(63, 69, 60, 65, NA, 68, 61, 70, 61, 59, 64, 69, 63, 63, NA, 72, 65, 64, 70, 63, 65)

heights_noNAs <- na.omit(heights)
heights_noNAs
median(heights, na.rm = TRUE)
heights_noNAs[heights_noNAs > 67]

# Factors
treatment <- factor(c("high", "low", "low", "medium", "high"))
levels(treatment)
levels(treatment) <- c('low', 'medium', 'high') # changing the default order of the levels
treatment
levels(treatment)
levels(treatment) <- c('L', 'M', 'H')

