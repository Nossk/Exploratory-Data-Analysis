
library(data.table)

#Load data for power consumption

powerData <- data.table::fread(input = "household_power_consumption.txt", na.strings = "?")

#Code to solve scientific notation problem

powerData[, Global_active_power := lapply(.SD, as.numeric), .SDcols = c("Global_active_power")]

#Create a new Column called "Data_Time" and format it to show the days of the week on the graph

powerData[, Date_Time := as.POSIXct(paste(Date, Time), format = "%d/%m/%Y %H:%M:%S")]

#Filter date from 2007-02-01 up until 2007-02-02

powerDataFiltered <- powerData[(Date_Time >= "2007-02-01") & (Date_Time < "2007-02-03")]

#Plot Data

png("Plot_2.png", width = 480, height = 480)

plot(x = powerDataFiltered[, Date_Time], y = powerDataFiltered[, Global_active_power], type = "l", xlab = "", ylab = "Global Active Power (Kilowatts)")

dev.off()
