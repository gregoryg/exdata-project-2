source("./load-data.R")
## Question 1: Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
message("Preparing question 1")
emissionsByYear <- aggregate(Emissions / 1000 ~ year, data = NEI, FUN = sum)

## Note to peer graders: this uses the less pretty base plotting system, as the assignment specifies
png(filename="plot1-points.png", pointsize=18)
graphics::plot(emissionsByYear$year, emissionsByYear$Emissions, xlab = "Year", ylab = "Total Emissions (kilotons)", type="b",
     main = "Total PM2.5 Emissions in USA 1999-2008")
dev.off()

## Another plot using the base plotting system
## png(filename="plot1-bar.png", pointsize=18)
## graphics::barplot(emissionsByYear$Emissions / 1000, names.arg = emissionsByYear$year, col = rainbow(20),
##         xlab = "Year", ylab = "Total Emissions (kilotons)", type="b",
##         main = "Total PM2.5 Emissions in USA 1999-2008")
## dev.off()

## This uses ggplot2; it's tricky, but I was able to color the bars by the Y axis values
png(filename="plot1.png", pointsize=18)
ggplot(data = emissionsByYear,
       mapping = aes(x = emissionsByYear$year,
                     y = emissionsByYear$Emissions, 
                     fill=emissionsByYear$Emissions)) + 
    geom_bar(stat = 'identity') +
    scale_x_continuous(breaks = c(emissionsByYear$year)) +
        labs(title="Total PM2.5 Emissions in USA 1999-2008",
             x ="Year",
             y = "Emissions (kilotons)") +
            scale_fill_gradient2(low='green', mid='yellow', high='red', space='Lab') +
                guides(fill=guide_legend(title="Air quality"))
dev.off()

