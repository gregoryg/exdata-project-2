source("./load-data.R")
## Question 2: Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008?
message("Preparing question 2")
emissionsByYear <- aggregate(Emissions ~ year, data = NEI[NEI$fips == "24510",], FUN = sum)
## Note to peer graders: the following plot uses the base plotting system
png(filename="plot2-points.png", pointsize=18)
plot(emissionsByYear$year, emissionsByYear$Emissions , xlab = "Year", ylab = "Total Emissions (tons)", type="b")
dev.off()

## Like before, this bar graph uses the base plotting system
## png(filename="plot2-bar-simple.png", pointsize=18)
## barplot(emissionsByYear$Emissions, names.arg = emissionsByYear$year, col = rainbow(20),
##         xlab = "Year", ylab = "Total Emissions (tons)", type="b",
##         main = "PM2.5 Emissions in City of Baltimore 1999-2008")
## dev.off()

## This plot colors the bars by the Y axis values
png(filename="plot2.png", pointsize=18)
ggplot(data = emissionsByYear,
       mapping = aes(x = emissionsByYear$year,
                     y = emissionsByYear$Emissions, 
                     fill=emissionsByYear$Emissions)) + 
    geom_bar(stat = 'identity') +
    scale_x_continuous(breaks = c(emissionsByYear$year)) +
        labs(title="PM2.5 Emissions in City of Baltimore 1999-2008",
             x ="Year",
             y = "Emissions (kilotons)") +
            scale_fill_gradient2(low='green', mid='yellow', high='red', space='Lab') +
                guides(fill=guide_legend(title="Air quality"))
dev.off()

