## Q4: Across the United States, how have emissions from coal combustion-related 
## sources changed from 1999–2008

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

## Subset NEI where SCC is related to coal, SCC numbers greped from SCCSCC$EI.Sector
coalNEI <- NEI[NEI$SCC %in% SCC[grepl("coal", SCC$EI.Sector, ignore.case = T),]$SCC, ]

require(ggplot2,ggrepel)
## Aggregate coal data by sum of emissions per year.
## Plot a line per type indicating if emissions have decreased or increase
p <- ggplot(aggregate(Emissions ~ year, coalNEI, sum)) + 
  aes(x = year, y = Emissions) + geom_point(color="#000099") + geom_line(color="#000099") 

## Changing plot theme and setting it transparent
p <- p + theme_light() + theme(plot.title = element_text(lineheight=.8, face="bold")) + 
  theme(plot.title = element_text(hjust = 0.5)) + 
  theme(panel.background = element_rect(fill = "transparent", colour = NA), 
        plot.background = element_blank(),
        legend.background = element_blank(),
        legend.key = element_blank())

## Set labels 
p <- p + xlab("Year") + ylab("PM2.5 Emissions [tons]") + 
  ggtitle("Coal Emissions in the U.S. (1999 - 2008)")

## Add data labels using ggrepel
p <- p + geom_text_repel(aes(label = sprintf("%0.1f", round(Emissions, digits = 1))),
                         size = 3, fontface = "bold", show.legend = FALSE, color="#000099")

## Saving all into a png file
png(filename = "plot4.png", width = 480, height = 480, bg = "transparent")
print(p)
dev.off()