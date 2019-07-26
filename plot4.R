#  plot4.R
#
#  Created by Adalberto Cubillo on 7/25/19.
#  Copyright © 2019 Adalberto Cubillo. All rights reserved.

library(tidyverse)

# Read RDS files.
NEI <- readRDS("./exdata_data_NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("./exdata_data_NEI_data/Source_Classification_Code.rds")

# Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

# Search for "coal" and "comb" (for combustion) in the SCC dataset 
# using the variables EI.Sector or Short.Name
comb_detected1 <- str_detect(tolower(SCC$EI.Sector), "comb")
coal_detected1 <- str_detect(tolower(SCC$EI.Sector), "coal")
comb_detected2 <- str_detect(tolower(SCC$Short.Name), "comb")
coal_detected2 <- str_detect(tolower(SCC$Short.Name), "coal")

# Subset the SCC dataset.
scc_comb_coal <- subset(SCC, (comb_detected1 & coal_detected1) | (comb_detected2 & coal_detected2))

# Subset NEI dataset with the selected SCC.
coal_emissions <- subset(NEI, NEI$SCC %in% scc_comb_coal$SCC)

# Group the coal emissions by year and then summarize the data by the total emissions.
coal_emissions_per_year <- coal_emissions %>% 
  group_by(year) %>%
  summarise(total_emissions = sum(Emissions))

# Set the plot device to PNG.
png(filename = "./plot4.png")

# Use the ggplot2 plotting system to make a plot answer this question.
ggplot(data = coal_emissions_per_year, 
       aes(x = year, y = total_emissions)) +
  geom_point() + geom_line() +
  labs(title = "Coal combustion-related total PM2.5 emissions \nby year", 
       y = "Emissions (tons)", x = "Year")

# Close the device and save the plot in the PNG image. 
dev.off()