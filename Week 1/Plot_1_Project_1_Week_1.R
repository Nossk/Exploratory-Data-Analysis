


library(data.table)

#Load data for power consumption

powerData <- data.table::fread(input = "household_power_consumption.txt", na.strings = "?")


#Code to solve scientific notation problem

powerData[, Global_active_power := lapply(.SD, as.numeric), .SDcols = c("Global_active_power")]

#Change data type of the date column to date format

powerData[, Date := lapply(.SD, as.Date, "%d/%m/%Y"), .SDcols = c("Date")]

#Filter dates from 2007/02/01 - 2007/02/02

powerData <- powerData[(Date >= "2007-02-01") & (Date <= "2007-02-02")]


png("Plot_1.png", width = 480, height = 480)


hist(powerData[, Global_active_power], main = "Global Active Power", xlab = "Global Active Power (kilowatts)", ylab = "Frequency", col = "Orange")


dev.off()





