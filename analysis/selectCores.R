#
# Quick interactive script to sub-select cores based on p-value
# TODO: Make into callable script with arguments
#

#
# Load source libraries
#
setwd("~/Git-Projects/Git-Research-Projects/cnprep_cores")
source("scripts/helperFunctions.R")

#
# Set the core p_threshold
#
p_threshold <- 0.05

event <- "AD"
output <- "hT_output"
dir <- "prev_run_7_27_2018_8_2"
rdsFile <- paste0("./", output, "/", dir, "/", event, "newCOREobjBP.rds")
tableFile <- paste0("./", output, "/", dir, "/", event, "coreTableBP.csv")
outputBed <- paste0("./", output, "/", dir, "/selectedCores/", event, "selectedCoresBP.bed")

#
# Get core information
#
obj <- readRDS(rdsFile) # Retrieve CORE object
coreTable <- read.table(tableFile, header = TRUE, sep = ",") # Retrieve CORE table CSV (since the table's scale is chromosome-based instead of absolute)

#
# Subset core information using p_threshold then write to file
#
coreTable <- coreTable[which(obj$p<p_threshold),] # Filter cores based on p-value threshold
coreTable <- coreTable[,c(2,3,4,5)] # Now convert to BED format
coreTable$p <- obj$p[unlist(obj$p < p_threshold)]
write.table(coreTable, sep = "\t", quote = FALSE, col.names = FALSE, row.names = FALSE, file = outputBed) # Write to bed file
