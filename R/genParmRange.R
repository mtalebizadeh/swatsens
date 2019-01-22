

genParmRange <- function(projectPath) {

  # Generating file indices from project directory
  # projectPath <- "/home/mk/Documents/swat_sens/SWAT/TxtInOut"
  fileNames <- list.files(projectPath)
  fileIndices <- c()
  for (fileName in fileNames) {
    if (endsWith(fileName, ".gw") &&
        !startsWith(fileName,"output")) {

      subasinNum <- sub(pattern = "[0]+",
                        replacement = "",
                        x = substr(fileName, 1,5))

      hruNum <- sub(pattern = "[0]+",
                    replacement = "",
                    x = substr(fileName, 6,9))

      fileIndices <- c(fileIndices,
                       paste("Idx_",
                             subasinNum,
                             "_",
                             hruNum,
                             sep = ""))
    }
  }
  # Generating input list containing SWAT parameters
  # list level -1
  rangeList = list(low=NA, up=NA)

  catgs <- list("hru" = kHruParmNames,
                "mgt" = kMgtParmNames,
                "gw"  =  kGwParmNames,
                "sol" = kSolParmNames)
  input = list()
  for (catg in names(catgs)) {

    catgList = list()
    for (parmName in catgs[[catg]]) {

      parmNameList = list()
      for (idx in fileIndices) {

        parmNameList[[idx]] = rangeList
        catgList[[parmName]] = parmNameList
        input[[catg]] = catgList
      }
    }
  }
  input
}
