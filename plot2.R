## Q2: Have total emissions from PM2.5 decreased in the Baltimore City, Maryland 
## (𝚏𝚒𝚙𝚜 == "𝟸𝟺𝟻𝟷𝟶") from 1999 to 2008? Use the base plotting system.

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

## Subset by fips ==24510 and aggregate data by sum of emissions per year.
## Plot a line indicating if emissions have decreased
png(filename = "plot2.png", width = 480, height = 480, bg = "transparent")
plot(aggregate(Emissions ~ year, subset(NEI, fips ==24510), sum), 
     type = "l", col = "darkred", xlab = "Year", ylab = "PM2.5 Emissions [tons]",
     main = "Total Emissions in Baltimore City (1999 - 2008)", bg = NA)
dev.off()