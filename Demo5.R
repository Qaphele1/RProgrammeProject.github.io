# Demo5

# Load libaries needed ----
library(tidyverse) # As always
library(readxl) # To read in Excel data
library(ggstatsplot) # ggplot2 plots with statistical details.

# Clear global environment of variables
rm(list = ls())

#install.packages("askgpt")
#library(askgpt)

# If Chat GPT is available you can ask it how to do
# things in R directly from the command line
# askgpt("How do I read an excel spreadsheet into R?")

# Read Excel data into a tibble.
# How can you tell that it is a tibble?
Students_2023 <- read_excel("Data/ALMX100_Students_2023.xlsx")

# Have a look at the data
View(Students_2023)

# As the data frame stands it could do with
# some cleaning. There are NA's that should be
# removed. Names in all caps are not good, etc.

# Convert Student_Name to title case
Students_2023$Student_Name <- 
  str_to_title(Students_2023$Student_Name)

# Separate student surname from other names
Students_2023 <- Students_2023 |> 
  separate_wider_delim(cols = Student_Name,
                       delim = ", ",
                       names = c("Surname", "First_name"))

# Get rid of the brackets (they cause an issue)
Students_2023$First_name <- gsub('[^[:alnum:] ]', ' ', 
                                 Students_2023$First_name)

# Choose only the first Name in the First_names variable
Students_2023$First_name <- word(Students_2023$First_name, 1)  

# How many full records are there?
count(drop_na(Students_2023))
df <- drop_na(Students_2023)

# The data are now in a suitable format to continue

# Calculate body mass index - it is a person's mass
# in kilograms divided by the square of their height
# in metres.
df <- df |> 
  mutate(BMI = Weight_kg / (Height_cm / 100)^2)
View(df)

# Is there a relationship between body mass and height?
# How would you go about determining this?
df |> 
  ggplot(aes(x = Height_cm, y = Weight_kg)) +
  geom_point()

# Looking at the plot suggests that there is 
# a relationship. As height increases do does
# weight. Looking at the data in a plot helps
# to indicate where there might be a problem
# with the data. The bottom two values on the
# plot look as though they might be out of place.


# Correlation test to see if there is a relationship
# between height and mass
cor.test(df$Height_cm, df$Weight_kg)

# Test to see if there is a linear relationship
# between height and mass
lm_df <- lm(Weight_kg ~ Height_cm, data = df)
summary(lm_df)

# ggplot to show the data for mass and height and
# the linear relationship. Assign to a plot object.
p1 <- df |> ggplot(aes(x = Height_cm, 
                 y = Weight_kg)) +
  geom_point() +
  geom_smooth(method = "lm") +
  labs(x = "Height (cm)",
       y = "Weight (kg)")

# View the plot object p1
p1

# View the plot object p1 using facet and
# the variable, Sex
p1 + facet_wrap(~Sex)

# Change the height to metres in the plot and
# put the axis labels on two lines
p2 <- df |> ggplot(aes(x = Height_cm / 100, 
                 y = Weight_kg)) +
  geom_point() +
  geom_smooth(method = "lm") +
  labs(x = "Height\n(m)",
       y = "Mass\n(kg)") +
  theme_minimal()
p2

# Use the ggstatsplot function ggscatterstats
# to compare the heights and weights of the 
# students
p3 <- ggscatterstats(df, 
               x = Height_cm, 
               y = Weight_kg,
               bf.message = F,
               type = "p",
               marginal = T,
               label.var = First_name,
               label.expression = Height_cm < 130 |
                 Height_cm > 200,
               xsidehistogram.args = list(binwidth = 10, 
                                          fill = "red"),
               ysidehistogram.args = list(binwidth = 10,
                                          fill = "green"),
               xlab = "Height in cm",
               ylab = "Weight in kg",
               title = "Relationship between Height and Weight for the 2023 ALMX100 Class"
               ) 

# View the plot
p3

# View the plot object p3 using facet and
# the variable, Sex
p3 + facet_wrap(~Sex, nrow = 1)


# What happens when you remove nrow = 1?
# What happens when you make nrow = 2?

# You can edit the df data frame using the
# fix function
fix(df)

# Change the regression line colour to red and get rid
# of the grey error band.

# Useful Books ----
# Another free online book to help you learn about R
browseURL("https://moderndive.com/")

# Yet another free online book - this one is very
# comprehensive by the guy who developed ggplot2
# and the idea of the tidyverse
browseURL("https://r4ds.hadley.nz/")

# Another free online book - this one is aimed at
# agriculture students in particular and biology 
# students in general
browseURL("https://www.statforbiology.com/_statbookeng/")



