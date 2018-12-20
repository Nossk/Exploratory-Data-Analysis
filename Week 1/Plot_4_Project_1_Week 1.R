
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

png("Plot_4.png")

plot(x = powerDataFiltered[, Date_Time], y = powerDataFiltered[, Global_active_power], type = "l", xlab = "", ylab = "Global Active Power")

plot(x = powerDataFiltered[, Date_Time], y = powerDataFiltered[, Voltage], type = "l")

plot(x = powerDataFiltered[, Date_Time], y = powerDataFiltered[, Sub_metering_1], type = "l", xlab = "", ylab = "Energy Sub Metering")
lines(powerDataFiltered[, Date_Time], powerDataFiltered[, Sub_metering_2], col = "red")
lines(powerDataFiltered[, Date_Time], powerDataFiltered[, Sub_metering_3], col = "blue")
legend("topright", col = c("black", "red", "blue"), c("Sub Metering 1 ", "Sub Metering 2 ", "Sub Metering 3 "), lty = c(1, 1), lwd = c(1, 1))


plot(x = powerDataFiltered[, Date_Time], y = powerDataFiltered[, Global_reactive_power], type = "l")


