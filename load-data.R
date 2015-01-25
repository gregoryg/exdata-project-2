## This file must be sourced by each of the plot creation R files
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
if (!exists("NEI")) {
    message("Loading NEI summary")
    NEI <- readRDS(nei_summary_fname)
}
if (!exists("SCC")) {
    message("Loading Source Classification Code Table")
    SCC <- readRDS(scc_fname)
}

## Questions 4-6 require subsetting "Coal combustion-related and "Motor vehicle" sources
## first, get "coal" related SCC rows
## Searching for "Coal" in SCC$Short.Name returns irrelevant rows
## "Coal" references in SCC$EI.Sector all have to do with coal combustion
if (!exists("coalCodes")) coalCodes <- SCC[grep("coal", SCC$EI.Sector, ignore.case=TRUE),]$SCC

## next, vehicle codes
## NEI$type is not a reliable filter for the question asked (*ALL* motor vehicles)
## SCC$SCC.Level.Two description refers to all types of vehicles (off-road, airport-only, on-road)
## vehicleCodes <- unique(NEI[NEI$type == "ON-ROAD" | NEI$type == "NON-ROAD",]$SCC)
if (!exists("vehicleCodes"))vehicleCodes <- SCC[grep("vehicle", SCC$SCC.Level.Two, ignore.case=TRUE),]$SCC
