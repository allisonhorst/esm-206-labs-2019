#-------------------------------
# ESM 206 Lab 1 - Meet RStudio, wrangling & viz basics
#-------------------------------

#-------------------------------
# Lab 1 objectives:
#-------------------------------

# By the end of Lab 1, you should be able to...

# Create a new .Rproj and add files to working directory
# Attach packages with library()
# Read in a CSV with readr::read_csv()
# Explore data with base functions (e.g. View, names, head, tail)
# Do some basic wrangling with dplyr (select, filter, mutate, group_by, summarize)
# Use the pipe operator
# Create basic graphs in ggplot2

# Step 0: make a pathway on our computer that you'll put all of your ESM 206 labs in. Maybe Documents > Bren courses > ESM 206 > Labs

# Step 1: Open RStudio, describe pieces of the RStudio environment

# Step 2: Create a new project called 'esm206_lab_1'. Why does this matter? Working directory = no file path/broken path issues. Notice that a folder now appears wherever you saved this project with the same name, and it contains a .Rproj file.

# Step 3: Create a few variables in the console (variable_name <- value/"string"). Notice they show up in the Environment. How would you store everything you did in the Console? And all errors/messages/etc. show up there. That's a problem for reproducibility & collaboration - hard to follow, no clear history, etc. We want to have a clear, reproducible story of our entire data analysis. One way: working in scripts.

# Step 4: Open a new R script. Introduce basics. What is a comment? Organizing sections? If I try to create some variables and press Enter after each line, nothing happens - how is this different from the Console?

#-------------------------
# 1. Attach packages
#-------------------------

# First, attach packages with library(package_name)
# You can only attach packages that are installed
# Run code with Command + Return, or Command + Shift + Return
# Ask: why does it make sense to include this in a script, versus running this in the Console?

library(tidyverse)
library(janitor)

#-------------------------
# 2. Read in data from a .csv file
#-------------------------

# We'll use readr::read_csv() to get data from a comma separated value (CSV) file. The general structure is:

# store_as_this <- read_csv("file_path/file_name.csv")

# If the file is in your working directory (i.e. in the project folder), then you don't need to add a file_path/ to find it because it's already we're R is pointed to.

hp_data <- read_csv("lab_1_materials/hp_aggression.csv")

# How do I know it worked? No errors, + look in 'Environment'

#--------------------------
# 3. Check it out (LOOK AT YOUR DATA)
#--------------------------

# How to view your data frame in "spreadsheet" format?
# You can click on the df name in the 'Environment' tab to run the View() function (see Console after clicking on the name - notice that this actually runs View). Others: names, head, tail, dim, summary, stringr, etc.

View(hp_data)
names(hp_data)
summary(hp_data)
ls()

# This format: tidy data

# Each variable is a column. Each row is an observation. This df is in great shape - not all will be. But for Week 1, we'll use fairly tidy data (for lab and Assignment 1).

#-------------------------
# 4. dplyr::select() - subset COLUMNS
#-------------------------

# dplyr::select(): choose/exclude/reorder *COLUMNS*

# Example: select only the columns 'character' and 'book'
# Way 1: No pipe

hp_ex_1 <- select(hp_data, character, book)

# Way 2: Meet the pipe operator %>% (does the same thing)
# Shortcut for pipe: Command + Shift + M
hp_ex_2 <- hp_data %>%
  select(character, book)

# The pipe is really nice for sequential operations (avoids excessive intermediate data frames, nesting functions, etc.). Think of adding the pipe as saying "and then..."

# Example: Select columns 'abb' through 'aggressions'
hp_ex_3 <- hp_data %>%
  select(abb:aggressions)

# Example: select columns 'character' through 'aggressions', excluding 'book':
hp_ex_4 <- hp_data %>%
  select(character:aggressions, -book)

# Example: Select book, character, and aggressions, in that order:
hp_ex_5 <- hp_data %>%
  select(book, character, aggressions)

#---------------------------
# 5. dplyr::filter() - conditionally subset ROWS
#---------------------------

# Use filter to set conditions that will decide which rows are kept/excluded in a new subset

# Example: only keep observations from the book "The Goblet of Fire"

hp_ex_6 <- hp_data %>%
  filter(book == "The Goblet of Fire")

# Some notes to keep in mind: (1) Case sensitive when trying to match words! (2) Note the double = (==) when looking for word matching

# Example: keep rows where the character abbreviation (abb) matches 'harr', 'herm', 'vold', OR 'ronw.' One way: use the vertical lin e '|' to indicate 'OR' within a filter statement:

hp_ex_7 <- hp_data %>%
  filter(abb == "harr" | abb == "herm" | abb == "vold" | abb == "ronw")

# Or, a less tedious way: look for matches within a string series:
hp_ex_8 <- hp_data %>%
  filter(abb %in% c("harr", "herm", "vold","ronw"))

# See ?"%in%" to see more details. It's basically a special operator for finding matches (binary - match? yes or no...if yes, keep it)

# Ex: Only keep rows where the book is "The Deathly Hallows" AND aggressions is greater than 5:

hp_ex_9 <- hp_data %>%
  filter(book == "The Deathly Hallows", aggressions > 5)

# Other operators also work: >=, <=, >, <, or if a value, use a single '='. Note: for 'AND' statements, you can either just use a comma, or use an ampersand (&), or do them as separate filtering steps

#----------------------
# 6. dplyr::mutate() - add columns, keep existing
#----------------------

# Use dplyr::mutate() to add variables to a data frame, while keeping existing (unless you explicitly overwrite)

# Example: Let's add a column that contains an 'aggression per mention' ratio (call new column 'apm').

hp_ex_10 <- hp_data %>%
  mutate(apm = aggressions/mentions)

#----------------------
# 7. dplyr::group_by() + dplyr::summarize()
#----------------------

# Use dplyr::group_by() to create 'groupings' by variable, then dplyr::summarize() to calculate a single value for each group & report a table

# Example: we want to group by character abbreviation, then find the total number of aggressions for all characters across all books.

np_ex_11 <- hp_data %>%
  group_by(abb) %>%
  summarize(tot_agg = sum(aggressions))

# Other summary statistics: mean, median, sd, var, max, min, etc.

#----------------------
# 8. Linking multiple wrangling steps with the pipe
#----------------------

# Example: We want to only keep rows that contain observations for Harry Potter (Harry), Voldemort, Hermione Granger, and Severus Snape . We also only want to keep the columns for character, book, and mentions. Then, create groups by character abbreviation and find the total number of mentions.

np_ex_12 <- hp_data %>%
  filter(character %in% c("Harry","Voldemort","Hermione Granger","Severus Snape")) %>%
  select(character, book, mentions) %>%
  group_by(character) %>%
  summarize(
    total = sum(mentions)
  )

#------------------------
# 9. Basic graphs with ggplot2
#------------------------

# A ggplot2 graph requires 3 things: (1) that you're using ggplot; (2) what data to plot, including what's x and y as relevant; (3) what type of graph (geom) to create

ggplot(data = np_ex_12, aes(x = character, y = total)) +
  geom_col() +
  labs(x = "Total mentions",
       y = "Character",
       title = "My Title!") +
  coord_flip()

# Let's make a scatterplot plot of aggressions v. mentions (across all characters, books, etc.)

ggplot(data = hp_data, aes(x = mentions, y = aggressions)) +
  geom_point(color = "purple") +
  theme_bw()

# Let's make a histogram of all aggression counts to see how they're distributed

ggplot(data = hp_data, aes(x = aggressions)) +
  geom_histogram(bins = 10)

# Now, a jitterplot of the number of aggressions by book:

ggplot(data = hp_data, aes(x = book, y = aggressions)) +
  geom_jitter(width = 0.1, alpha = 0.5, aes(color = book), show.legend = FALSE) +
  coord_flip()

#-----------------------
# 10. Shutting down
#-----------------------

# All of the code you need to reproduce everything you've done should exist in your script. That means that if your script is saved (press save now), then you can close the project without saving the workspace, graphs, etc.

# Then, if you want to open it again, just double click on the .Rproj file, notice that all your files are right in the 'Files' tab (including your script), click on the script to open it, then run the entire thing with Command + Shift + Enter to recreate all of your great work!

# ---------------------
# Shortcuts & goodies
# ---------------------

# ALT/option key + (minus) to add an arrow <-
# Command + Shift + C for multiple lines commenting out/in
# RStudio Cheatsheets

#-----------------------
# END LAB 1
#-----------------------




