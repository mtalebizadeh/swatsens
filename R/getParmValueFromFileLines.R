


getParmValueFromFileLines <- function(fileLines, parmName) {
  # Reads a parameter value.
  #
  # Args:
  #   fileLines: A character vector containing input file lines, i.e., output of
  #       readLines() function.
  #   parmName: Parameter name in SWATSENSE
  #

  if (isPlantParm(parmName)) {
    parmValue <- getParmValueFromPlantFileLines(fileLines, parmName)
  } else {
    parmValue <- getParmValueFromNonPlantFileLines(fileLines, parmName)
  }
  parmValue
}

getParmValueFromPlantFileLines <- function(fileLines, parmName) {

  if (getPlantParmName(parmName) == "BIO_E") {
    parmValue <- getBIO_EValueFromPlantFileLines(fileLines, parmName)
  } else if (getPlantParmName(parmName) == "USLE_C") {
    parmValue <- getUSLE_CValueFromPlantFileLines(fileLines, parmName)
  } else {
    stop("Not a valid plant Parameter!")
  }
   parmValue
}

getBIO_EValueFromPlantFileLines <- function(fileLines, parmName) {
  plantName <- getPlantName(parmName)
  targetLineIndex <- grep(pattern = plantName, fileLines) + 1
  targetLine <- fileLines[targetLineIndex]
  parmValue <- unlist(strsplit(targetLine,"\\s+"))[2]
  as.numeric(parmValue)
}

getUSLE_CValueFromPlantFileLines <- function(fileLines, parmName) {
  plantName <- getPlantName(parmName)
  targetLineIndex <- grep(pattern = plantName, fileLines) + 3
  targetLine <- fileLines[targetLineIndex]
  parmValue <- unlist(strsplit(targetLine,"\\s+"))[3]
  as.numeric(parmValue)
}

getPlantName <- function(parmName) {
  parmNameInSWAT <- getParmNameInSWAT(parmName)
  plantName <- unlist(strsplit(parmNameInSWAT, "[.]"))[1]
  plantName
}

getPlantParmName <- function(parmName) {
  parmNameInSWAT <- getParmNameInSWAT(parmName)
  plantParmName <- unlist(strsplit(parmNameInSWAT, "[.]"))[2]
  plantParmName
}


getParmValueFromNonPlantFileLines <- function(fileLines, parmName) {
  parmNameInSWAT <- getParmNameInSWAT(parmName)
  logicalVec <- grepl(pattern = parmNameInSWAT, fileLines)
  targetLine <- fileLines[logicalVec]
  parmValue <- unlist(strsplit(x = targetLine, split = "[|]"))[1]
  parmValue <- as.numeric(trimws(parmValue))
  parmValue
}

getParmNameInSWAT <- function(parmName) {
  if (isPlantParm(parmName)) {
    # plant parm name in SWAT consitis of two parts, e.g. FRST.BIO_E
    parmNameInSWAT <- unlist(strsplit(parmName, "plant."))[2]
  } else {
    parmNameInSWAT <- unlist(strsplit(parmName, "[.]"))[2]
  }
  parmNameInSWAT
}








