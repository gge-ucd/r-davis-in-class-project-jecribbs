#Week 2 Homework
# Jenny Cribbs
# R-Davis 07 October 2021

set.seed(15) #setting the starting point to 15
hw2 <- runif(50, 4, 50) # reates a uniform distribution with 50 numbers between 4-50
hw2 <- replace(hw2, c(4,12,22,27), NA) #replaces the hw2 distribution
hw2 #view hw2 object

#Problem 1 Take your hw2 vector and remove all the NAs then select all the numbers between 14 and 38 inclusive, call this vector prob1.
hw2 <- na.omit(hw2) #remove nas
prob1 <- hw2[hw2 >= 14 & hw2 <= 38] # returns values from hw2 between 14 and 38 inclusive

#PROBLEM 2: Multiply each number in the prob1 vector by 3 to create a new vector called times3. Then add 10 to each number in your times3 vector to create a new vector called plus10.
times3 <- prob1 *3
plus10 <- times3 + 10

#PROBLEM 3: Select every other number in your plus10 vector by selecting the first number, not the second, the third, not the fourth, etc
plus10[seq(1, 23, 2)] #show the sequence from 1-23 in plus10 by 2s (i.e. every other number)
