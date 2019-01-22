

readParms <- function(parmNames, prjFolderPath) {
  # Reads parameter value from SWAT input files.
  #
  # Args:
  #   parmNames: A vector of characters containing parameter names in swatsens
  #
  # Returns:
  #   A named vector of numbers containing SWAT parameter values

  parmNames <- c("hru.HRU_FR.Idx_1_1", "hru.SLSUBBSN.Idx_1_1",
                 "mgt.NMGT.Idx_1_1", "mgt.IGRO.Idx_1_1",
                 "gw.GW_DELAY.Idx_1_1", "gw.SHALLST.Idx_1_1")
  prjFolderPath <- "/home/mk/Documents/swat_sens/SWAT/TxtInOut"


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
    con <- file(file.path(prjFolderPath, parmFileName))
    fileLines <- readLines(con)
    for (parmName in grpFileAndParmNames[[parmFileName]]) {
      parmNameInSWAT <- unlist(strsplit(parmName, "[.]"))[2]
      parmValue <- c(readParmInFile(fileLines, parmNameInSWAT))
      names(parmValue) <- parmName
      parmValues <- c(parmValues, parmValue)
    }
    close(con)
  }

  return(parmValues)
}
