#  plot2.R
#
#  Created by Adalberto Cubillo on 7/25/19.
#  Copyright © 2019 Adalberto Cubillo. All rights reserved.

# Read RDS files.
NEI <- readRDS("./exdata_data_NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("./exdata_data_NEI_data/Source_Classification_Code.rds")

# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips=="24510") 
# from 1999 to 2008?
baltimore_nei <- subset(NEI, NEI$fips == "24510")
baltimore_emissions_per_year <- aggregate(Emissions ~ year, baltimore_nei, sum)

# Set the plot device to PNG.
png(filename = "./plot2.png")

# Use the base plotting system to make a plot answering this question.
barplot(baltimore_emissions_per_year$Emissions, names.arg = baltimore_emissions_per_year$year,
        ylab = "Emissions (tons)", xlab = "Year", ylim = c(0, 4000),
        main = "Baltimore, Maryland total PM2.5 emissions\nfrom all sources by year")

# Close the device and save the plot in the PNG image. 
dev.off()