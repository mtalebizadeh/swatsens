

getParmValues <- function(parmNames, projectPath) {
  # Reads parameter value from SWAT input files.
  #
  # Args:
  #   parmNames: A vector of characters containing parameter names in swatsens
  #
  # Returns:
  #   A named vector of numbers containing SWAT parameter values

  grpFileAndParmNames <- groupParmNamesUsingFileNames(parmNames)
  parmValues <- c()
  for (parmFileName in names(grpFileAndParmNames) ) {
    con <- file(file.path(projectPath, parmFileName))
    fileLines <- readLines(con)
    for (parmName in grpFileAndParmNames[[parmFileName]]) {
      parmValue <- c(getParmValueFromFileLines(
        fileLines,
        parmName)
        )
      names(parmValue) <- parmName
      parmValues <- c(parmValues, parmValue)
    }
    close(con)
  }

  return(parmValues)
}

groupParmNamesUsingFileNames <- function(parmNames) {
  # Groups parameters residing in each input file

  parmFileNames <- c()
  for (parmName in parmNames) {
    parmFileNames <- c(parmFileNames, getParmFileName(parmName))
  }
  fileAndParmNames <- cbind.data.frame(parmFileNames,
                                       parmNames,
                                       stringsAsFactors=FALSE)
  grpFileAndParmNames <- split(x = fileAndParmNames[["parmNames"]],
                               f = fileAndParmNames[["parmFileNames"]])
}

getParmValueFromFileLines <- function(fileLines, parmName) {
  # Reads a parameter value.
  #
  # Args:
  #   fileLines: A character vector containing input file lines, i.e., output of
  #       readLines() function.
  #   parmName: Parameter name in SWATSENSE
  #
  # Returns: SWAT parameter value.

  if (isPlantParm(parmName)) {
    parmValue <- getParmValueFromPlantFileLines(fileLines, parmName)
  } else {
    parmValue <- getParmValueFromNonPlantFileLines(fileLines, parmName)
  }
  parmValue
}

getParmValueFromPlantFileLines <- function(fileLines, parmName) {

  targetLineIndex <- getTargetPlantParmLineIndex(fileLines, parmName)
  targetLine <- fileLines[targetLineIndex]

  if (getPlantParmName(parmName) == "BIO_E") {
    parmValue <- unlist(strsplit(targetLine,"\\s+"))[2]
  } else if (getPlantParmName(parmName) == "USLE_C") {
    parmValue <- unlist(strsplit(targetLine,"\\s+"))[3]
  } else {
    stop("Not a valid plant Parameter!")
  }
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
  targetParmLineIndex <- getTargetNonPlantParmLineIndex(fileLines, parmName)
  targetLine <- fileLines[targetParmLineIndex]
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

getTargetPlantParmLineIndex <- function(fileLines, parmName) {
  plantName <- getPlantName(parmName)
  if (getPlantParmName(parmName) == "BIO_E") {
    targetParmLineIndex <- grep(pattern = plantName, fileLines) + 1
  } else if (getPlantParmName(parmName) == "USLE_C") {
    targetParmLineIndex <- grep(pattern = plantName, fileLines) + 3
  } else{
    stop("Not a valid plant parameter name!")
  }
  targetParmLineIndex
}

getTargetNonPlantParmLineIndex <- function(fileLines, parmName) {
  parmNameInSWAT <- getParmNameInSWAT(parmName)
  targetParmLineIndex <- grep(pattern = parmNameInSWAT, fileLines)
  targetParmLineIndex
}










