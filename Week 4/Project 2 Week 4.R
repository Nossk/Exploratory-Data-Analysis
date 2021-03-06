
#Goal of this assignment is to explore the National Emissions Inventory database and see what it say about fine particulate matter pollution in the United states over the 10-year period 1999-2008.

library(data.table)


#Mapping from the SCC digit strings in the Emissions table to the actual name of the PM2.5 source. The sources are categorized in a few different ways from more general to more specific

SCC <- data.table::as.data.table(x = readRDS(file = "Source_Classification_Code.rds"))

#Data frame with all of the PM2.5 emissions data for 1999, 2002, 2005, and 2008. For each year, the table contains number of tons of PM2.5 emitted from a specific type of source for the entire year.

emissions_data <- data.table::as.data.table(x = readRDS(file = "summarySCC_PM25.rds"))


#Question 1: Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008

emissions_data[, Emissions := lapply(.SD, as.numeric), .SDcols = c("Emissions")]
totalEmissions <- emissions_data[, lapply(.SD, sum, na.rm = TRUE), .SDcols = c("Emissions"), by = year]


#Create holder file for plot and barplot with data of interest

png(filename = "Question_1_Barplot_1.png")

barplot(totalEmissions[, Emissions], names = totalEmissions[, year], xlab = "Years", ylab = "Emissions", main = "Emissions over the Years")

#Close Connection
dev.off()


#Question 2: Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips=="24510") from 1999 to 2008? Use the base plotting system to make a plot answering this question.

emissions_data[, Emissions := lapply(.SD, as.numeric), .SDcols = c("Emissions")]

totalEmissions <-emissions_data[fips == "24510", lapply(.SD, sum, na.rm = TRUE), .SDcol = c("Emissions"), by = "year"]

png(filename = "Question_2_Barplot_2.png")

barplot(totalpm25[, Emissions], names = totalpm25[, year], xlab = "Years", ylab = "Emissions", main = "Emissions over the Years")

dev.off()


#Question 3: Of the four types of sources indicated by the type(point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999-2008 for Baltimore City?
            #Which have seen increases in emissions from 1999-2008? Use the ggplot2 plotting system to make a plot answer this question.

#Extract Baltimore Data with the FIPS code 24510

Baltimore_Data <- emissions_data[fips == "24510"]

png("Question_3_Baltimore_Chart.png")

ggplot(Baltimore_Data, aes(x = factor(year), y = Emissions, fill = type)) + geom_bar(stat = "identity") + facet_grid(.~ type, scales = "free", space = "free") + 
    labs(x = "year", y = expression("Total PM"[2.5]* "Emission(Tons)")) + labs(title = expression("PM"[2.5]* "Emissions, Baltimore City 1999-2008 by Source Type"))

dev.off()


#Question 4: Across the United States, how have emissions from coal combustion-related sources changed from 1999-2008?

#Subset Coal combustion related emissions from the Emissions data

combustionData <- grepl("comb", SCC[, SCC.Level.One], ignore.case = TRUE)
coalRelated <- grepl("coal", SCC[, SCC.Level.Four], ignore.case = TRUE)
combustionSCC <- SCC[combustionData & coalRelated, SCC]
combustionEmissions <- emissions_data[emissions_data[, SCC] %in% combustionSCC]


png("Question_4_Coal_Emissions.png")

ggplot(combustionEmissions, aes(x = factor(year), y = Emissions/10^5)) + geom_bar(stat = "Identity", fill = "#9999FF", width = 0.75) +
    labs(x = "year", y = expression("Total PM"[2.5]*" Emission (10^5 Tons")) + labs(title = expression("PM"[2.5]*" Coal Combustion Emissions Across the US from 1999-2008"))

dev.off()


#Question 5: How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?

#Obtain Vehicle Emission Data

conditions <- grepl("vehicle", SCC[, SCC.Level.Two], ignore.case = TRUE)
vehiclesSCC <- SCC[conditions, SCC]
vehicleChange <- emissions_data[emissions_data[, SCC] %in% vehiclesSCC]

#Filter for Baltimore

vehicleChangeBaltimore <- vehicleChange[fips == "24510"]


png("Question_5_Vehicle_Emissions_Baltimore_Chart.png")

ggplot(vehicleChangeBaltimore, aes(x = factor(year), y = Emissions)) + geom_bar(stat = "Identity", fill = "#FF9999", width = 0.75) +
    labs(x = "year", y = expression("Total PM"[2.5]*" Emission (10^5 Tons)")) + labs(title = expression("PM"[2.5]*" Emissions from Vehicles in Baltimore from 1999-2008"))

dev.off()


#Question 6: Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037").
            #Which city has seen greater changes over time in motor vehicle emissions?


#Obtain Vehicle information data

conditions <- grepl("vehicle", SCC[, SCC.Level.Two], ignore.case = TRUE)
vehiclesSCC <- SCC[conditions, SCC]
vehicleChange <- emissions_data[emissions_data[, SCC] %in% vehiclesSCC]

#Subste the data for Baltimore and Los Angeles using thier FIPS

vehicleChangeBaltimore <- vehicleChange[fips == "24510"]
vehicleChangeBaltimore[, city := c("Baltimore City")]

vehicleChangeLosAngeles <- vehicleChange[fips == "06037"]
vehicleChangeLosAngeles[, city := c("Los Angeles County")]

#Combine both datasets into one for easire manipulation

vehicleChangeBothCities <- rbind(vehicleChangeBaltimore, vehicleChangeLosAngeles)


png("Question_6_Baltimore_VS_Los_Angeles_Chart.png")

ggplot(vehicleChangeBothCities, aes(x = factor(year), y = Emissions, fill = city)) + geom_bar(aes(fill = year), stat = "Identity") + facet_grid(scales = "free", space = "free", .~ city) +
    labs(x = "year", y = expression("PM"[2.5]*" Emission in Kilos-Ton")) + labs(title = expression("PM"[2.5*" Emissions from vehicles in Baltimore City and Los Angeles County from 1999-2008"]))

dev.off()


#Resources for Project 2
https://www.rstudio.com/wp-content/uploads/2015/03/ggplot2-cheatsheet.pdf
https://www.rdocumentation.org/packages/ggplot2/versions/1.0.1/topics/geom_bar
https://cran.r-project.org/web/packages/data.table/data.table.pdf





