library(ggplot2)
##
dataurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
datazipname <- "FNEI_data.zip"
nei_summary_fname <- "summarySCC_PM25.rds"
scc_fname <- "Source_Classification_Code.rds"

if (!file.exists(datazipname)) {
    download.file(dataurl, destfile=datazipname, method="curl")
}

if (!file.exists(nei_summary_fname) | !file.exists(scc_fname))
    unzip(zipfile=datazipname, overwrite=FALSE)
message("Loading NEI summary")
NEI <- readRDS(nei_summary_fname)
message("Loading Source Classification Code Table")
SCC <- readRDS(scc_fname)

## Question 1: Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
message("Preparing question 1")
emissionsByYear <- aggregate(Emissions / 1000 ~ year, data = NEI, FUN = sum)

## Note to peer graders: this uses the less pretty base plotting system, as the assignment specifies
png(filename="plot1-points.png", pointsize=18)
plot(emissionsByYear$year, emissionsByYear$Emissions, xlab = "Year", ylab = "Total Emissions (kilotons)", type="b",
     main = "Total PM2.5 Emissions in USA 1999-2008")
dev.off()

## Another plot using the base plotting system
png(filename="plot1-bar.png", pointsize=18)
barplot(emissionsByYear$Emissions / 1000, names.arg = emissionsByYear$year, col = rainbow(20),
        xlab = "Year", ylab = "Total Emissions (kilotons)", type="b",
        main = "Total PM2.5 Emissions in USA 1999-2008")
dev.off()

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

## Question 2: Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008?
message("Preparing question 2")
emissionsByYear <- aggregate(Emissions ~ year, data = NEI[NEI$fips == "24510",], FUN = sum)
## Note to peer graders: the following plot uses the base plotting system
png(filename="plot2-points.png", pointsize=18)
plot(emissionsByYear$year, emissionsByYear$Emissions , xlab = "Year", ylab = "Total Emissions (tons)", type="b")
dev.off()

## Like before, this bar graph uses the base plotting system
png(filename="plot2-bar-simple.png", pointsize=18)
barplot(emissionsByYear$Emissions, names.arg = emissionsByYear$year, col = rainbow(20),
        xlab = "Year", ylab = "Total Emissions (tons)", type="b",
        main = "PM2.5 Emissions in City of Baltimore 1999-2008")
dev.off()

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

## Question 3: Of the four types of sources indicated by the type
## (point, nonpoint, onroad, nonroad) variable, which of these four
## sources have seen decreases in emissions from 1999-2008 for
## Baltimore City? Which have seen increases in emissions from
## 1999-2008?Of the four types of sources indicated by the type
## (point, nonpoint, onroad, nonroad) variable, which of these four
## sources have seen decreases in emissions from 1999-2008 for
## Baltimore City? Which have seen increases in emissions from
## 1999-2008?

message("Preparing question 3")
## Aggregate by type by year, summing emissions; limit to Baltimore
qdata <- aggregate(Emissions ~ type+year, data = NEI[NEI$fips == "24510",], FUN = sum)

png(filename="plot3.png", pointsize=18)
ggplot(data=qdata, aes(x=factor(year), y=Emissions, group=factor(type), color=factor(type))) + geom_line() + geom_point()
dev.off()

## Questions 4-6 require subsetting "Coal combustion-related and "Motor vehicle" sources
## first, get "coal" related SCC rows
## Searching for "Coal" in SCC$Short.Name returns irrelevant rows
## "Coal" references in SCC$EI.Sector all have to do with coal combustion
coalCodes <- SCC[grep("coal", SCC$EI.Sector, ignore.case=TRUE),]$SCC

## next, vehicle codes
## NEI$type is not a reliable filter for the question asked (*ALL* motor vehicles)
## SCC$SCC.Level.Two description refers to all types of vehicles (off-road, airport-only, on-road)
## vehicleCodes <- unique(NEI[NEI$type == "ON-ROAD" | NEI$type == "NON-ROAD",]$SCC)
vehicleCodes <- SCC[grep("vehicle", SCC$SCC.Level.Two, ignore.case=TRUE),]$SCC

## Question 4: Across the United States, how have emissions from coal combustion-related sources changed from 1999-2008?
message("Preparing question 4")
qdata <- aggregate(Emissions ~ year, data = NEI[NEI$SCC %in% coalCodes,], FUN = sum)
png(filename="plot4.png", pointsize=18)
plot(qdata$year, qdata$Emissions / 1000, xlab = "Year", ylab = "Total Emissions (kilotons)", type="b", main="Coal Combustion-related Emissions by Year")
dev.off()

## Question 5: How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?
message("Preparing question 5")
qdata <- aggregate(Emissions ~ year, data = NEI[NEI$fips == "24510" & NEI$SCC %in% vehicleCodes,], FUN = sum)
png(filename="plot5.png", pointsize=18)
plot(qdata$year, qdata$Emissions, xlab = "Year", ylab = "Total Emissions (tons)", type="b", main="Motor Vehicle Emissions in Baltimore by Year")
dev.off()

## Question 6: Compare emissions from motor vehicle sources in
## Baltimore City with emissions from motor vehicle sources in Los
## Angeles County, California (fips == "06037"). Which city has seen
## greater changes over time in motor vehicle emissions?
message("Preparing question 6")
qdata <- aggregate(Emissions ~ year+fips, data = NEI[NEI$fips %in% c("24510", "06037") & NEI$SCC %in% vehicleCodes,], FUN = sum)
png(filename="plot6.png", pointsize=18)
ggplot(data=qdata, aes(x=factor(year), y=Emissions, group=factor(fips), color=factor(fips))) + geom_line() + geom_point()
dev.off()
