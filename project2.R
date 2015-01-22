library(ggplot2)
##
dataurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
datazipname <- "FNEI_data.zip"
nei_summary_fname <- "summarySCC_PM25.rds"
scc_fname <- "summarySCC_PM25.rds"

sccxref <- "Source_Classification_Code.rds"

if (!file.exists(datazipname)) {
    download.file(dataurl, destfile=datazipname, method="curl")
}

if (!file.exists(nei_summary_fname) | !file.exists(scc_fname))
    unzip(zipfile=datazipname, overwrite=FALSE)
NEI <- readRDS(nei_summary_fname)
SCC <- readRDS(scc_fname)

## Question 1: Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
emissionsByYear <- aggregate(Emissions ~ year, data = NEI, FUN = sum)

png(filename="plot1.png", pointsize=18)
plot(emissionsByYear$year, emissionsByYear$Emissions / 1000, xlab = "Year", ylab = "Total Emissions (kilotons)", type="b"
     main = "Total PM2.5 Emissions in USA 1999-2008")
dev.off()

## Question 2: Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008?
emissionsByYear <- aggregate(Emissions ~ year, data = NEI[NEI$fips == "24510",], FUN = sum)
png(filename="plot2.png", pointsize=18)
plot(emissionsByYear$year, emissionsByYear$Emissions / 1000, xlab = "Year", ylab = "Total Emissions (kilotons)", type="b")
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

## Aggregate by type by year, summing emissions; limit to Baltimore
gort <- aggregate(Emissions ~ type+year, data = NEI[NEI$fips == "24510",], FUN = sum)

png(filename="plot3.png", pointsize=18)
ggplot(data=gort, aes(x=factor(year), y=Emissions, group=factor(type), color=factor(type))) + geom_line() + geom_point()
dev.off()

## Questions 4-6 require subsetting "Coal combustion-related and "Motor vehicle" sources
## first, get "coal" related SCC rows
coalCodes <- SCC[grep(".*Coal.*", SCC$Short.Name, ignore.case=TRUE),]$SCC
## next, vehicle codes
vehicleCodes <- unique(NEI[NEI$type == "ON-ROAD" | NEI$type == "NON-ROAD",]$SCC)

## Question 4: Across the United States, how have emissions from coal combustion-related sources changed from 1999-2008?
gort <- aggregate(Emissions ~ year, data = NEI[NEI$SCC %in% coalCodes,], FUN = sum)
png(filename="plot4.png", pointsize=18)
plot(gort$year, gort$Emissions / 1000, xlab = "Year", ylab = "Total Emissions (kilotons)", type="b", main="Coal Combustion-related Emissions by Year")
dev.off()

## Question 5: How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?
gort <- aggregate(Emissions ~ year, data = NEI[NEI$fips == "24510" & NEI$SCC %in% vehicleCodes,], FUN = sum)
png(filename="plot5.png", pointsize=18)
plot(gort$year, gort$Emissions / 1000, xlab = "Year", ylab = "Total Emissions (kilotons)", type="b", main="Motor Vehicle Emissions in Baltimore by Year")
dev.off()

## Question 6: Compare emissions from motor vehicle sources in
## Baltimore City with emissions from motor vehicle sources in Los
## Angeles County, California (fips == "06037"). Which city has seen
## greater changes over time in motor vehicle emissions?
gort <- aggregate(Emissions ~ year+fips, data = NEI[NEI$fips %in% c("24510", "06037") & NEI$SCC %in% vehicleCodes,], FUN = sum)
png(filename="plot6.png", pointsize=18)
ggplot(data=gort, aes(x=factor(year), y=Emissions, group=factor(fips), color=factor(fips))) + geom_line() + geom_point()
dev.off()
