#This is to change the settings to English 
Sys.setlocale("LC_ALL", "English")
#Download the required resources. Used for reading the big file
if (!"LaF" %in% installed.packages()) 
    install.packages(LaF)
library(LaF)
# Open a LaF connection. LaF cannot read headers from the file,
# so they need to be set when constructing the LaF connection.
con<-laf_open_csv(
    filename="household_power_consumption.txt",
    sep=";", skip=1, trim=TRUE,
    column_types=c("character", "character", rep("numeric", 7)), # Add column types here
    column_names=c("Date", "Time", "Global_active_power", "Global_reactive_power"
                    , "voltage", "Global_intensity", "Sub_metering_1", "Sub_metering_2" , "Sub_metering_3") # Add column names here
)

# Filter using LaF. LaF reads the file in parts and 
# only retains records that meet the filter criteria
data<-con[con$Date[] %in% c("1/2/2007", "2/2/2007"),]

png(filename="plot4.png", width = 480, height = 480, units = "px")
days <- as.POSIXct(paste(data$Date, data$Time), format="%d/%m/%Y %H:%M:%S")
par(mfrow = c(2,2), mar= c(4,4,4,2) , oma=c(2,1,1,1))
{
    # Plot 1
    plot(days
         , data$Global_active_power
         , ylab= "Global Active Power"
         , xlab =""
         , type = "l")
    
    # Plot 2
    plot(days
         , data$voltage
         , ylab= "Voltage"
         , xlab= "datetime"
         , type = "l"
    )
    # Plot 3
    plot( days
          , data$Sub_metering_1, col = "black", type = "l"
         , ylab= "Energy Sub metering"
         , xlab= ""
    )
    points(days, data$Sub_metering_2, col = "red", type = "l" )
    points(days, data$Sub_metering_3, col = "blue", type = "l" )
    legend( "topright"
            , legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
            , lty = 1
            , col = c("black", "red", "blue")
            , bty = "n")
    #plot 4
    plot(days
         , data$Global_reactive_power
         , ylab= "Global_reactive_power"
         , xlab= "datetime"
         , type = "l"
    )
}
dev.off()

