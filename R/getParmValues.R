

getParmValues <- function(parmNames, projectPath) {
  # Reads parameter value from SWAT input files.
  #
  # Args:
  #   parmNames: A vector of characters containing parameter names in swatsens
  #
  # Returns:
  #   A named vector of numbers containing SWAT parameter values

  # parmNames <- c("hru.HRU_FR.Idx_1_1", "hru.SLSUBBSN.Idx_1_1",
  #                "mgt.NMGT.Idx_1_1", "mgt.IGRO.Idx_1_1",
  #                "gw.GW_DELAY.Idx_1_1", "gw.SHALLST.Idx_1_1",
  #                 "plant.FRST.BIO_E")
  #
  # projectPath <- "E:/Sensitivity_Projects/SWATExp/example/TxtInOut"


  parmFileNames <- c()
  for (parmName in parmNames) {
    parmFileNames <- c(parmFileNames, getParmFileName(parmName))
  }
  print(parmFileNames)
  fileAndParmNames <- cbind.data.frame(parmFileNames,
                                       parmNames,
                                       stringsAsFactors=FALSE)
  # Grouping parameters residing in each input file
  grpFileAndParmNames <- split(x = fileAndParmNames[["parmNames"]],
                               f = fileAndParmNames[["parmFileNames"]])
  parmValues <- c()
  for (parmFileName in names(grpFileAndParmNames) ) {
    con <- file(file.path(projectPath, parmFileName))
    fileLines <- readLines(con)
    for (parmName in grpFileAndParmNames[[parmFileName]]) {
      #parmNameInSWAT <- unlist(strsplit(parmName, "[.]"))[2] # Needs Help!
      parmValue <- c(getParmValueFromFileLines(
        fileLines,
        getParmNameInSWAT(parmName))
        )
      names(parmValue) <- parmName
      parmValues <- c(parmValues, parmValue)
    }
    close(con)
  }

  return(parmValues)
}


getParmNameInSWAT <- function(parmName) {
  if (!isPlantParm(parmName)) {
    parmNameInSWAT <- unlist(strsplit(parmName, "[.]"))[2]
  } else {
    parmNameInSWAT <- unlist(strsplit(parmName, "plant."))[2]
  }
  parmNameInSWAT
}







