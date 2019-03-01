


getParmValueFromFileLines <- function(fileLines, parmNameInSWAT) {
  # Reads a parameter value.
  #
  # Args:
  #   fileLines: A character vector containing input file lines, i.e., output of
  #       readLines() function.
  #   parmNameInSWAT: Parameter name as it appears in an SWAT input file
  #
  if (isPlantParm(parmNameInSWAT)) {
    parmValue <- getParmValueFromPlantFileLines(fileLines, parmNameInSWAT)
  } else {
    parmValue <- getParmValueFromNonPlantFileLines(fileLines, parmNameInSWAT)
  }
  parmValue
}

getParmValueFromPlantFileLines <- function(fileLines, parmNameInSWAT) {
  parmNameInSWATSplit <- unlist(strsplit(parmNameInSWAT, "[.]"))
  plantName <- parmNameInSWATSplit[1]
  plantParmName <- parmNameInSWATSplit[2]

  if (plantParmName == "BIO_E") {
    targetLineIndex <- grep(pattern = plantName, fileLines) + 1
    targetLine <- fileLines[targetLineIndex]
    parmValue <- unlist(strsplit(targetLine,"\\s+"))[2]

  } else if (plantParmName == "USLE_C") {
    targetLineIndex <- grep(pattern = plantName, fileLines) + 3
    targetLine <- fileLines[targetLineIndex]
    parmValue <- unlist(strsplit(targetLine,"\\s+"))[3]

  } else {
    stop("Not a valid plant Parameter!")
  }
   parmValue
}

getParmValueFromNonPlantFileLines <- function(fileLines, parmNameInSWAT) {
  logicalVec <- grepl(pattern = parmNameInSWAT, fileLines)
  targetLine <- fileLines[logicalVec]
  parmValue <- unlist(strsplit(x = targetLine, split = "[|]"))[1]
  parmValue <- as.numeric(trimws(parmValue))
  parmValue
}








