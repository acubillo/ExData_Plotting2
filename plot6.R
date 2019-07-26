#  plot6.R
#
#  Created by Adalberto Cubillo on 7/25/19.
#  Copyright © 2019 Adalberto Cubillo. All rights reserved.

library(tidyverse)
library(gridExtra)

# Read RDS files.
NEI <- readRDS("./exdata_data_NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("./exdata_data_NEI_data/Source_Classification_Code.rds")

# Compare emissions from motor vehicle sources in Baltimore City with emissions 
# from motor vehicle sources in Los Angeles County, California (fips=="06037"). 
# Which city has seen greater changes over time in motor vehicle emissions?

# Subset the SCC dataset using the level one that indicates the motor vehicles sources are "Mobile Sources".
# See the following url: https://gispub.epa.gov/neireport/2014/ section 3. Source Types and Sectors.
scc_comb_motor_vehicle <- SCC[SCC$SCC.Level.One == "Mobile Sources", ]

# Subset NEI dataset with the selected SCC.
motor_vehicle_emissions <- subset(NEI, NEI$SCC %in% scc_comb_motor_vehicle$SCC)

# Subset NEI dataset using Baltimore City and Los Angeles County fips.
baltimore_angeles_motor_vehicle_emissions <- subset(motor_vehicle_emissions, 
                                                    motor_vehicle_emissions$fips == "24510" | 
                                                      motor_vehicle_emissions$fips == "06037")

# Group the motor vehicle emissions by year and fips and then summarize the data by the total emissions.
baltimore_angeles_motor_vehicle_emissions_per_year <- baltimore_angeles_motor_vehicle_emissions %>% 
  group_by(year, fips) %>%
  summarise(total_emissions = sum(Emissions))

# Calculate the total percentage of change between 1999 and 2008 for each city.
# With the formula: (total_emissions_1999 - total_emissions_2008) / total_emissions_1999 * 100.
la_total_1999 <- (baltimore_angeles_motor_vehicle_emissions_per_year %>% 
                    filter(year == "1999" & fips == "06037"))$total_emissions
la_total_2008 <- (baltimore_angeles_motor_vehicle_emissions_per_year %>% 
                    filter(year == "2008" & fips == "06037"))$total_emissions
ba_total_1999 <- (baltimore_angeles_motor_vehicle_emissions_per_year %>% 
                    filter(year == "1999" & fips == "24510"))$total_emissions
ba_total_2008 <- (baltimore_angeles_motor_vehicle_emissions_per_year %>% 
                    filter(year == "2008" & fips == "24510"))$total_emissions
la_diff_percentage <- (la_total_1999 - la_total_2008) / la_total_1999 * 100
ba_diff_percentage <- (ba_total_1999 - ba_total_2008) / ba_total_1999 * 100

df_diff_percentage <- data.frame(city = c("Los Angeles County", "Baltimore City"),
                                 difference = c(la_diff_percentage, ba_diff_percentage))

# Set the plot device to PNG.
png(filename = "./plot6.png", width = 800, height = 400, units = "px")

# Use the ggplot2 plotting system to make a plot answer this question.
plot1 <- ggplot(data = baltimore_angeles_motor_vehicle_emissions_per_year, 
       aes(x = year, y = total_emissions, col = fips)) +
  geom_point() + geom_line() +
  labs(title = "Motor Vehicle total PM2.5 emissions \nby year", 
       y = "Emissions (tons)", x = "Year") +
  scale_color_discrete(name = "City", labels = c("Los Angeles County", "Baltimore City"))

# Create a plot to show the total difference.
plot2 <- ggplot(data = df_diff_percentage, aes(x = city, y = difference, fill = forcats::fct_rev(city))) +
  geom_bar(stat = "identity") +
  labs(title = "Total PM2.5 motor vehicle emissions difference", 
       y = "Difference (%)", x = "City") + 
  scale_fill_discrete(name = "City")

# Combine both plots into a single device.
grid.arrange(plot1, plot2, ncol = 2)

# Close the device and save the plot in the PNG image. 
dev.off()