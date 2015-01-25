source("./load-data.R")
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
ggplot(data=qdata, aes(x=year, y=Emissions, group=type, color=type)) +
    geom_line() +
    geom_point() +
    labs(title="PM2.5 Emissions in City of Baltimore by Source Type")
dev.off()


