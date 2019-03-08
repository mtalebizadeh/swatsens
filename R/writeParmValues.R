
writeParmValues <- function(parmValues, projectPath) {
  # Write parameter values in input files.
  #
  # Arge:
  #   parmValues: A named vector, containing parameter names (in swatsens) and
  #               their values.
  #   projectPath: folder path where files are written.
  #
  # Returns: Void

  parmNames <- names(parmValues)
  grpFileAndParmNames <- groupParmNamesUsingFileNames(parmNames)

  for (parmFileName in names(grpFileAndParmNames) ) {
    con <- file(file.path(projectPath, parmFileName))
    fileLines <- readLines(con)
    for (parmName in grpFileAndParmNames[[parmFileName]]) {
      targetFileLineIndex <- getTargetFileLineIndex(fileLines, parmName)
      startPosition <- getParmStartPositionInLine(parmName)
      formatString <- getParmFormatString(parmName)
      substring(text = fileLines[targetFileLineIndex],
                first = startPosition
                ) <- sprintf(formatString, parmValues[parmName])
      writeLines(fileLines, con)
    }
    close(con)
  }
}

getTargetFileLineIndex <- function(fileLines, parmName) {
  if (isPlantParm(parmName)) {
    targetFileLineIndex <- getTargetPlantParmLineIndex(fileLines, parmName)
  } else {
    targetFileLineIndex <- getTargetNonPlantParmLineIndex(fileLines, parmName)
  }
  targetFileLineIndex
}

getParmStartPositionInLine <- function(parmName) {
  if (isPlantParm(parmName)) {
    plantParmName <- getPlantParmName(parmName)
     if (plantParmName == "BIO_E") {
       startPosition <- 0
     } else if(plantParmName == "USLE_C") {
       startPosition <- 20
     } else {
       stop("Not a valid plant parameter!")
     }
  } else {
    startPosition <- 0
  }
  startPosition
}

getParmFormatString <- function(parmName) {
  if (isPlantParm(parmName)) {
    plantParmName <- getPlantParmName(parmName)
    kParmName2FormatStringMap[plantParmName]
  } else {
    parmNameInSWAT <- getParmNameInSWAT(parmName)
    kParmName2FormatStringMap[parmNameInSWAT]
  }
}
