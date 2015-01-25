source("./load-data.R")
## Question 6: Compare emissions from motor vehicle sources in
## Baltimore City with emissions from motor vehicle sources in Los
## Angeles County, California (fips == "06037"). Which city has seen
## greater changes over time in motor vehicle emissions?
message("Preparing question 6")
qdata <- aggregate(Emissions ~ year+fips, data = NEI[NEI$fips %in% c("24510", "06037") & NEI$SCC %in% vehicleCodes,], FUN = sum)
png(filename="plot6.png", pointsize=18)
ggplot(data=qdata, aes(x=year, y=Emissions, group=fips, color=fips)) + geom_line() + geom_point() +
    labs(title="Motor Vehicle Emissions Los Angeles County vs City of Baltimore")
dev.off()
