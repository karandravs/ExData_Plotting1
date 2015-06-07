# Create and download temporary zip file from url
temp <- tempfile()
remoteFile <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(remoteFile,temp)

# Unzip and delete zip file
unzip(temp,overwrite = TRUE)
unlink(temp)

# Get .txt file
filename <- list.files(pattern="*.txt")
library("sqldf")
# read subsetted data using read.csv.sql into data variable
data<-read.csv.sql(filename,sql="select * from file where Date in ('1/2/2007','2/2/2007')",
                   header=TRUE,stringsAsFactors=FALSE,sep=';')
closeAllConnections()

date_time <- strptime(paste(data$Date,data$Time),format = "%d/%m/%Y %H:%M:%S")
# set png device 
png("plot4.png", width = 480, height = 480)

# set up frame
par(mfrow = c(2,2))

# create plot
plot(date_time, data$Global_active_power,xlab="", ylab = "Global Active Power", type = "l")
plot(date_time, data$Voltage, xlab = "datetime" , ylab = "Voltage", type = "l")
plot(date_time,data$Sub_metering_1, xlab="", ylab = "Energy sub metering", type = "l", col = "black")
        # lines
        lines(date_time, y = data$Sub_metering_2, type = "l", col = "red" )
        lines(date_time, y = data$Sub_metering_3, type = "l", col = "blue" )
        # create legend 
        legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
               col = c("black", "red", "blue"), lty = c(1,1,1), bty="n")
plot(date_time, data$Global_reactive_power, ylab = "Global_reactive_power", xlab = "datetime" , type = "l")
# close
dev.off()