## Q6: Compare emissions from motor vehicle sources in Baltimore City with emissions from 
## motor vehicle sources in Los Angeles County, California (𝚏𝚒𝚙𝚜 == "𝟶𝟼𝟶𝟹𝟽"). 

## Check if data files are present, if not download and unzip
if (!(file.exists("summarySCC_PM25.rds")) | 
    !(file.exists("Source_Classification_Code.rds"))) {
  download.file(
    "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", 
    "exdata-data-NEI_datat.zip")
  unzip(zipfile="exdata-data-NEI_datat.zip")
}

## Read data sets
##NEI <- adRDS("summarySCC_PM25.rds")
##SCC <- adRDS("Source_Classification_Code.rds")

## Subset NEI where SCC is related to vehicles, SCC numbers greped from SCC$EI.Sector
vehiclesNEI <- NEI[NEI$SCC %in% SCC[grepl("vehicles", SCC$EI.Sector, 
                                          ignore.case = T),]$SCC, ]

## Replace the fips numbers with county name
vehiclesNEI[which(vehiclesNEI$fips=="06037"),"fips"] <- "Los Angeles"
vehiclesNEI[which(vehiclesNEI$fips=="24510"),"fips"] <- "Baltimore"

require(ggplot2,ggrepel)
## Subset by fips == 24510 or 06037 and aggregate data by sum of emissions per year.
## Plot lines indicating if emissions have decreased or increase
p <- ggplot(aggregate(Emissions ~ year+fips, 
                      subset(vehiclesNEI, fips == "Los Angeles" | fips == "Baltimore"), sum)) + 
  aes(x = year, y = Emissions, group = fips, color = fips) + geom_point() + geom_line() 

## Changing plot theme and setting it transparent
p <- p + theme_light() + theme(plot.title = element_text(lineheight=.8, face="bold")) + 
  theme(plot.title = element_text(hjust = 0.5)) + 
  theme(panel.background = element_rect(fill = "transparent", colour = NA), 
        plot.background = element_blank(),
        legend.background = element_blank(),
        legend.key = element_blank())

## Add data labels using ggrepel
p <- p + geom_text_repel(aes(label = sprintf("%0.1f", round(Emissions, digits = 1))),
                         size = 3, fontface = "bold", show.legend = FALSE)

## Set labels 
p <- p + xlab("Year") + ylab("PM2.5 Emissions [tons]") + labs(color="U.S. County") +
  ggtitle("Vehicle Emissions in Baltimore City and Los Angeles")

## Sa (1999 - 2008)ving all into a png file
png(filename = "plot6.png", width = 480, height = 480, bg = "transparent")
print(p)
dev.off()