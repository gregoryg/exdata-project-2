source("./load-data.R")
## Question 4: Across the United States, how have emissions from coal combustion-related sources changed from 1999-2008?
message("Preparing question 4")
qdata <- aggregate(Emissions ~ year, data = NEI[NEI$SCC %in% coalCodes,], FUN = sum)
png(filename="plot4.png", pointsize=18)
plot(qdata$year, qdata$Emissions / 1000, xlab = "Year", ylab = "Total Emissions (kilotons)", type="b", main="USA Coal Combustion-related Emissions")
dev.off()

