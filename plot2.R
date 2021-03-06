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
png("plot2.png", width = 480, height = 480)

# create plot
plot(date_time, data$Global_active_power, type = "l", xlab = "", ylab = "Global Active Power (kilowatts)")

# close
dev.off()