## Q1: Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
## Using the base plotting system, make a plot showing the total PM2.5 emission from all 
## sources for each of the years 1999, 2002, 2005, and 2008.

## Check if data files are present, if not download and unzip
if (!(file.exists("summarySCC_PM25.rds")) | 
      !(file.exists("Source_Classification_Code.rds"))) {
  download.file(
    "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", 
    "exdata-data-NEI_datat.zip")
  unzip(zipfile="exdata-data-NEI_datat.zip")
}

## Read data sets
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Aggregate data by sum of emissions per year.
## Plot a line indicating if emissions have decreased
png(filename = "plot1.png", width = 480, height = 480, bg = "transparent")
plot(aggregate(Emissions ~ year, NEI, sum), type = "l", col = "darkblue",
     xlab = "Year", ylab = "PM2.5 Emissions [tons]",
     main = "Total Emissions (1999 - 2008)", bg = NA)
dev.off()