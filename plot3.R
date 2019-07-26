#  plot3.R
#
#  Created by Adalberto Cubillo on 7/25/19.
#  Copyright © 2019 Adalberto Cubillo. All rights reserved.

library(tidyverse)

# Read RDS files.
NEI <- readRDS("./exdata_data_NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("./exdata_data_NEI_data/Source_Classification_Code.rds")

# Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, 
# which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? 
# Which have seen increases in emissions from 1999–2008? 
baltimore_nei <- subset(NEI, NEI$fips == "24510")

# Group the emissions by type and year and then summarize the data by the total emissions.
baltimore_emissions_per_year_per_type <- baltimore_nei %>% 
  group_by(type, year) %>%
  summarise(total_emissions = sum(Emissions))

# Set the plot device to PNG.
png(filename = "./plot3.png")

# Use the ggplot2 plotting system to make a plot answer this question.
ggplot(data = baltimore_emissions_per_year_per_type, 
       aes(x = year, y = total_emissions)) +
  geom_point() + geom_line() +
  facet_grid(rows = vars(baltimore_emissions_per_year_per_type$type)) +
  labs(title = "Baltimore, Maryland total PM2.5 emissions \nby sources and year", 
       y = "Emissions (tons)", x = "Year")

# Close the device and save the plot in the PNG image. 
dev.off()