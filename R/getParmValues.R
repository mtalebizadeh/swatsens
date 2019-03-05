

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
  print(parmFileNames)
  fileAndParmNames <- cbind.data.frame(parmFileNames,
                                       parmNames,
                                       stringsAsFactors=FALSE)
  grpFileAndParmNames <- split(x = fileAndParmNames[["parmNames"]],
                               f = fileAndParmNames[["parmFileNames"]])
}








