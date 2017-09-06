## Q3: Of the four types of sources indicated by the 𝚝𝚢𝚙𝚎 (point, nonpoint, 
## onroad, nonroad) variable, which of these four sources have seen decreases 
## in emissions from 1999–2008 for Baltimore City? Which have seen increases 
## in emissions from 1999–2008? Use the ggplot2 plotting system

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

require(ggplot2,ggrepel)
## Subset by fips ==24510 and aggregate data by sum of emissions per year.
## Plot a line per type indicating if emissions have decreased or increase
p <- ggplot(aggregate(Emissions ~ year + type, subset(NEI, fips ==24510), sum)) + 
  aes(x = year, y = Emissions, group = type, colour = type) + geom_point() + geom_line() 

## Changing plot theme and setting it transparent
p <- p + theme_light() + theme(plot.title = element_text(lineheight=.8, face="bold")) + 
  theme(plot.title = element_text(hjust = 0.5)) + 
  theme(panel.background = element_rect(fill = "transparent", colour = NA), 
        plot.background = element_blank(),
        legend.background = element_blank(),
        legend.key = element_blank())

## Set labels 
p <- p + xlab("Year") + ylab("PM2.5 Emissions [tons]") + labs(color='Type') + 
  ggtitle("Total Emissions in Baltimore City (1999 - 2008)")

## Add data labels using ggrepel
p <- p + geom_text_repel(aes(label = sprintf("%0.1f", round(Emissions, digits = 1))),
                         size = 3, fontface = 'bold', show.legend = FALSE)

## Saving all into a png file
png(filename = "plot3.png", width = 480, height = 480, bg = "transparent")
print(p)
dev.off()