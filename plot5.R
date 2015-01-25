source("./load-data.R")
## Question 5: How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?
message("Preparing question 5")
qdata <- aggregate(Emissions ~ year, data = NEI[NEI$fips == "24510" & NEI$SCC %in% vehicleCodes,], FUN = sum)
png(filename="plot5.png", pointsize=18)
plot(qdata$year, qdata$Emissions, xlab = "Year", ylab = "Total Emissions (tons)", type="b", main="Motor Vehicle Emissions in Baltimore")
dev.off()
