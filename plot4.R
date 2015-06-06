## Library plot1 created June 6th 2015 by German Blanco

## This R script uses the "Electric Power consumption" dataset 
## nfrom the "UC Irvine Machine Learning Repository" in order
## to produce the forth graffic of the "Exploratory Data Analysis"
## course from John Hopkins University. 

## In a first step, the script checks if the data file is present
## in the current working directory. If it is not, it downloads the
## original zip file from its location and decompresses the file.
## In a second step the script processes the input file to create a
## matrix with only the required variables from the time interval
## in focus (2007-02-01 to 2007-02-02).
## Then the graphic is plotted to the screen.
## Finally the result is saved in a PNG file.

data.file.name <- "household_power_consumption.txt"
data.zip.name <- "data.zip"
output.file.name <- "plot4.png"
data.file.url <- 
    "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

## Downloading and decompressing data if file is not present

if (!file.exists(data.file.name)) {
    if (0 != download.file(data.file.url, destfile=data.zip.name)) {
        stop("error downloading file")
    }
    if (length(unzip(data.zip.name)) == 0) {
        stop("error decompressing file")
    }
    if (!file.remove(data.zip.name)) {
        warning("error removing zip file")
    }
}

## Selecting the two relevant days and only the relevant variables
colClasses <- c(rep("character", 2), rep("numeric", 3), "NULL", rep("numeric", 3))
data <- read.table(data.file.name,
                   header = FALSE,
                   sep=";",
                   skip=66637,
                   nrows=2880,
                   colClasses = colClasses)
if (length(data) == 0) {
    stop("error reading data file")
}

## Creating one POSIXlt time stamp and the variable to be plotted

times <- strptime(paste(data[[1]], data[[2]]), format="%d/%m/%Y %X")
data <- cbind(times, data[3:8])

## Creating the plot in PNG file

png(filename = output.file.name,
    width = 480, height = 480, units = "px")
par(mfcol=c(2, 2))
plot(data[[1]], data[[2]],
     ylab="Global Active Power",
     xlab="",
     type="l")
plot(data[[1]], data[[5]],
     ylab="Energy sub metering",
     xlab="",
     type="l")
lines(data[[1]], data[[6]],
      col="red3")
lines(data[[1]], data[[7]],
      col="blue3")
legend("topright",
       lty=c(1,1,1),
       col=c("black", "red", "blue"),
       bty="n",
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
plot(data[[1]], data[[4]],
     ylab="Voltage",
     xlab="datetime",
     type="l")
plot(data[[1]], data[[3]],
     ylab="Global_reactive_power",
     xlab="datetime",
     type="l")
dev.off()