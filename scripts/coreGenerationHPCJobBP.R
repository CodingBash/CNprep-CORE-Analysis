#
# This script generates CORES from input files in BP units (instead of SNP/bin units).
# This script is not interactive and is meant to be ran on a HPC job from a shell script.
#

args <- commandArgs(trailingOnly = TRUE)

#
# Set script arguments
#
event <- "A" 
outputCsv <- "coreTable.csv"
outputObj <- "newCOREobj.rds"
if (length(args) == 1){
  event <- args[1]
} else if (length(args) == 2){
  event <- args[1]
  outputCsv <- args[2]	
} else if (length(args) >= 3){
  event <- args[1]
  outputCsv <- args[2]
  outputObj <- args[3]
}

setwd("~/code/cnprep_cores")
source("./scripts/coreGenerationLibrary.R")
source("./scripts/helperFunctions.R")

events <- c(event)
sample_dir <- "./resources/cnprep_data/prev_run_7_27_2018_8"

#
# Get CORE input
#
samples <- load_samples(classes = c("T", "F", "M"), sampleList = "./resources/sampleList.csv")
chromosomeSizes <- readRDS("./resources/chromosomeSizes.rds")

inputCORESegments <- selectCnprepSegmentsWithEvent(events, samples, sample_dir, 0.001, probes = FALSE, silent = FALSE)
inputCOREBoundaries <- generateInputCOREBoundaries(chromosomeSizes)
print("Prepared all inputs - now running CORE")

#
# Run CORE
#
outputCOREobj <- runCORE(inputCORESegments, inputCOREBoundaries, distrib="Grid", maxmark=150, nshuffle=500, seedme=123, njobs=8)
print("CORE run complete")

#
# Save CORE object
# WARNING: The coreTable in the CORE object may not be in chromosomal location units. See CORE table output
#
saveRDS(outputCOREobj, outputObj)
print(paste("Saved CORE obj to", outputObj, sep = ""))


#
# Save CORE table
#
CORETable <- retrieveCORETable(outputCOREobj, chromosomeSizes, rescaleOutput = TRUE)
write.csv(CORETable, outputCsv)
print(paste("Saved coreTable as", outputCsv, sep = ""))

print("script complete")
