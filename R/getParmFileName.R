


getParmFileName <- function(parmName) {
  # Returns file name in SWAT

  #parmName <- "sol.HRU_FR.Idx_10_4"
  #"sub.CH_K1.Sub_1
  #wwq.RHOQ
  #plant.BIO_E

  if (isHruLevelParm(parmName) ||
      isSubbasinLevelParm(parmName)) {
    getHruOrSubLevelFileName(parmName)
  } else if (isGlobalLevelParm(parmName)) {
    getGLobalLevelFileName(parmName)
  } else if (isPlantParm(parmName)) {
    getPlantFileName(parmName)
  } else {
    stop("Not a valid parameter name!")
  }
}

isHruLevelParm <- function(parmName) {
  any(
    startsWith(parmName,
               prefix = c("mgt", "hru", "mgt", "gw"))
  )
}

isSubbasinLevelParm <- function(parmName) {
  any(isSubParm(parmName),
      isRteParm(parmName)
      )
}

isSubParm <- function(parmName) {
  startsWith(x = parmName, prefix = "sub")
}

isRteParm <- function(parmName) {
  startsWith(x = parmName, prefix = "rte")
}




isGlobalLevelParm <- function(parmName) {
  any(startsWith(parmName,
                 prefix = c("wwq", "bsn"))
  )
}

isPlantParm <- function(parmName) {
  startsWith(parmName,
                 prefix = "plant")
}

getHruOrSubLevelFileName <- function(parmName) {
  splitParmName <- unlist(strsplit(parmName, "[.]"))
  inputFileSuffix <- paste(".", splitParmName[1], sep="")
  parmNameInSWAT <- splitParmName[2]
  subasinAndHruNumber <- strtoi(unlist(strsplit(splitParmName[3], "[_]")))
  subasinFormatString <- "%05d"
  hruFromatString <- "%04d"
  subasinLabel <- sprintf(fmt = subasinFormatString, subasinAndHruNumber[2])
  if (isSubbasinLevelParm(parmName)) {
    hruNumLabel <- "0000"
  } else {
    hruNumLabel = sprintf(fmt = hruFromatString, subasinAndHruNumber[3])
  }

  hruOrSubLevelFileName <- paste(subasinLabel, hruNumLabel, inputFileSuffix, sep="")
}

getGLobalLevelFileName <- function(parmName) {
  inputFileSuffix <- unlist(strsplit(parmName, "[.]"))[1]
  globalLevelFileName <- paste("basins", ".", inputFileSuffix, sep = "")
}

getPlantFileName <- function(parmName) {
  plantFileName <- "plant.dat"
}

