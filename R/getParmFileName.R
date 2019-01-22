


getParmFileName <- function(parmName) {
  # Returns file name in SWAT

  #parmName <- "sol.HRU_FR.Idx_10_4"
  splitParmName <- unlist(strsplit(parmName, "[.]"))
  if (length(splitParmName) == 3) {
    inputFileSuffix <- paste(".", splitParmName[1], sep="")
    parmNameInSWAT <- splitParmName[2]
    subasinAndHruNumber <- strtoi(unlist(strsplit(splitParmName[3], "[_]")))
    subasinFormatString <- "%05d"
    hruFromatString <- "%04d"
    subasinLabel <- sprintf(fmt = subasinFormatString, subasinAndHruNumber[2])
    hruNumLabel <- sprintf(fmt = hruFromatString, subasinAndHruNumber[3])
    inputFileName <- paste(subasinLabel, hruNumLabel, inputFileSuffix, sep="")

  } else {
    stop("only supports parameters in .hru, .mgt, .gw, .sol files!")
  }
  return(inputFileName)
}
