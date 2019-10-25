# --------------
# Part 3 Key
# ESM 206 Lab 4
# --------------

# Lab prompt: https://docs.google.com/document/d/1KX6_bKA8BOO0NdsUviVi0HCT-q9iTCtTYsS1dGNQJfU/edit?usp=sharing

# Note: Students will have created a separate
# git-enabled R project for Part 3
# In that project, subfolders 'data' and 'final_graphs' created
# And drop the 'disease_burden.csv' file into 'data'

# That's where this example starts...

# Data from Institute for Health Metrics and Evaluations
# http://ghdx.healthdata.org/record/ihme-data/gbd-2010-mortality-results-1970-2010

# Attach packages

library(tidyverse)
library(janitor)
library(here)

db <- read_csv(here("data","disease_burden.csv")) %>%
  clean_names() %>%
  rename(deaths_per_100k = death_rate_per_100_000)

# View(db)

# Subset (US, Japan = lowest infant death rates, Afghanistan = highest infant death rates)

db_sub <- db %>%
  filter(country_name %in% c("United States", "Japan", "Afghanistan", "Somalia")) %>%
  filter(age_group == "0-6 days", sex == "Both")

# Graph
# New things: annotation + vertical line

ggplot(data = db_sub) +
  geom_line(aes(x = year,
                 y = deaths_per_100k,
                 color = country_name)) +
  scale_color_manual(values = c("black", "blue", "magenta", "orange")) +
  annotate(geom = "text",
           x = 1985,
           y = 2.2e5,
           label = "Afghanistan",
           size = 2.5) +
  geom_vline(xintercept = 2000,
             lty = 2) +
  theme_minimal()

ggsave(here("final_graphs","disease_graph.png"), width = 5, height = 3)
# End Part 3



