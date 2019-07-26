#  plot1.R
#
#  Created by Adalberto Cubillo on 7/25/19.
#  Copyright © 2019 Adalberto Cubillo. All rights reserved.

# Read RDS files.
NEI <- readRDS("./exdata_data_NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("./exdata_data_NEI_data/Source_Classification_Code.rds")

# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
sum_emissions_per_year <- aggregate(Emissions ~ year, NEI, sum)

# Set the plot device to PNG.
png(filename = "./plot1.png")

# Using the base plotting system, make a plot showing the total PM2.5 emission from all 
# sources for each of the years 1999, 2002, 2005, and 2008.
barplot(sum_emissions_per_year$Emissions, names.arg = sum_emissions_per_year$year,
     ylab = "Emissions (tons)", xlab = "Year",
     main = "Total PM2.5 emissions from all sources by year")

# Close the device and save the plot in the PNG image. 
dev.off()