#  plot5.R
#
#  Created by Adalberto Cubillo on 7/25/19.
#  Copyright © 2019 Adalberto Cubillo. All rights reserved.

library(tidyverse)

# Read RDS files.
NEI <- readRDS("./exdata_data_NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("./exdata_data_NEI_data/Source_Classification_Code.rds")

# How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

# Subset the SCC dataset using the level one that indicates the motor vehicles sources are "Mobile Sources".
# See the following url: https://gispub.epa.gov/neireport/2014/ section 3. Source Types and Sectors.
scc_comb_motor_vehicle <- SCC[SCC$SCC.Level.One == "Mobile Sources", ]

# Subset NEI dataset with the selected SCC.
motor_vehicle_emissions <- subset(NEI, NEI$SCC %in% scc_comb_motor_vehicle$SCC)

# Subset NEI dataset using Baltimore City fips.
baltimore_motor_vehicle_emissions <- subset(motor_vehicle_emissions, 
                                            motor_vehicle_emissions$fips == "24510")

# Group the motor vehicle emissions by year and then summarize the data by the total emissions.
baltimore_motor_vehicle_emissions_per_year <- baltimore_motor_vehicle_emissions %>% 
  group_by(year) %>%
  summarise(total_emissions = sum(Emissions))

# Set the plot device to PNG.
png(filename = "./plot5.png")

# Use the ggplot2 plotting system to make a plot answer this question.
ggplot(data = baltimore_motor_vehicle_emissions_per_year, 
       aes(x = year, y = total_emissions)) +
  geom_point() + geom_line() +
  labs(title = "Motor Vehicle total PM2.5 emissions \nby year in Baltimore City, Maryland", 
       y = "Emissions (tons)", x = "Year")

# Close the device and save the plot in the PNG image. 
dev.off()