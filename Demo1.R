# This is a demo script showing how to do stuff in R

# Some books ----
browseURL("http://bookdown.org")
browseURL("https://r-universe.dev/search/")


# Install required packages if needed ----
#install.packages("tidyverse")


# Load required packages ----
library(tidyverse)


# Scalars ----
# Scalars are vectors with a single value
a <- 3
b <- 4
class(a)

# Examples of scalar calculations
a * b
a - b
a / b
sqrt(a) *  b * pi

# This will give an error because "a" and "b" are
# not scalars but character values
"a" * "b"


# Vectors ----
# Vectors contain multiple values of the same type
# Create a vector using the concatenate function c()
v1 <- c(1,2,3,4,5,6,7,8,9,10)

# By typing the vector name and pressing Ctrl-Enter
# you can print the vector to the console
v1

# The above is a shortcut for print(v1)
print(v1)

# It is easier to use this notation to create the same
# vector
v1a <- c(1:10)

# What is the class of v1a?
class(v1a)

# Use the summary function to get a summary of the 
# vector v1a
summary(v1a)

# Use the built in data vector called letters to 
# create a vector of letters from characters 11 to 20
# using the subsetting operator [] and concatenate 
# function 
v2 <- c(letters[11:20])

# Use the rnorm() function to create a sequence of 100
# values and assign them to the v3 variable object.
# rnorm takes a random sample of numbers n, from 
# a normal distribution with a mean of, in this case
# 20 and a sd of 2
v3 <- rnorm(100, mean = 20, sd = 2)
v3

# What is the mean of v3?
mean(v3)
# Notice that the mean is not 20 but it is close 
# to it. (It could be exactly 20 but more often than
# not it wont be.)


# Data frames ----
# Create a data frame using the vectors v1 and v2
df <- data.frame(values = v1,letters = v2)

# Show the first four rows of the data frame
head(df, 4)

# Show the last four rows of the data frame
tail(df, 2)

# Show the rows, 1, 3 and 10 and both columns 
df[c(1,3,10),]

# Create a data frame using vectors v1, v2 and v3
df_3 <- data.frame(v1,v2,v3)
class(df_3)
View(df_3)


# Plotting data ----
# Use ggplot to plot the v3 column in the 
# df_3 data frame as a density plot. Note
# that we are only using on column of the data
# on the x axis. geom_density calculate the values
# for the y axis and shows the distribution of the
# different values on the x axis
df_3 |> 
  ggplot(aes(x = v3)) +
  geom_density()

# You can do the same thing with a histogram plot
df_3 |> 
  ggplot(aes(x = v3)) +
  geom_histogram()

# Change the number of bins
df_3 |> 
  ggplot(aes(x = v3)) +
  geom_histogram(bins = 10)

# Add some colour
df_3 |> 
  ggplot(aes(x = v3)) +
  geom_histogram(bins = 10,
                 colour = "red",
                 fill = "green")

# Plot the letters (v2) on the x axis and the random
# normal distribution numbers on the y axis using
# a boxplot
df_3 |> 
  ggplot(aes(x = v2, y = v3, fill = v2)) +
  geom_boxplot(colour = "black",
               show.legend = F) # do not show the legend
# What does this plot show us?
# What do the dots represent?

# Create a new data frame by summarising v3 
# to create means based on the letter group (v2).
df_3_mean <- df_3 |> 
  group_by(v2) |> 
  summarise(mean_by_letter = mean(v3))

# Add the means to the plot above
df_3 |> 
  group_by(v2) |> 
  ggplot(aes(x = v2, y = v3, color = v2)) +
  geom_boxplot(show.legend = F) +
  geom_point(data = df_3_mean, 
             aes(x = v2, y = mean_by_letter),
             show.legend = F, 
             shape = 4,
             size = 2)
# Compare the means and the medians in the plot.
# What does this tell us?
