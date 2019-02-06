

genParmRange <- function(projectPath) {

  # Generating file indices from project directory
  # projectPath <- "E:/Sensitivity_Projects/SWATExp/example/TxtInOut"

  # Default parameter range:
  rangeList = list(low=NA, up=NA)

  # HRU-level parameters inside .hru, .mgt, .gw, .sol files
  catgs <- list("hru" = kHruParmNames,
                "mgt" = kMgtParmNames,
                "gw"  = kGwParmNames,
                "sol" = kSolParmNames)

  input = list()
  hruLevelFileNames <- list.files(path = projectPath,
                             pattern = "[0-9]+([.]gw)$")
  fileIndices <- c()
  for (hruLevelFileName in hruLevelFileNames) {
      subasinNum <- sub(pattern = "[0]+",
                        replacement = "",
                        x = substr(hruLevelFileName, 1,5))

      hruNum <- sub(pattern = "[0]+",
                    replacement = "",
                    x = substr(hruLevelFileName, 6,9))

      fileIndices <- c(fileIndices,
                       paste("Idx_",
                             subasinNum,
                             "_",
                             hruNum,
                             sep = ""))
  }

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

  # Subbasin-level parameters inside .sub, .rte
  subasinLevelCatgs <- list("sub" = kSubParmNames,
                            "rte" = kRteParmNames)

  rteFileNames <- list.files(path = projectPath,
                             pattern = "[0-9]+([.]rte)$")
  subasinIndices <- c()
  for (rteFileName in rteFileNames) {

      subasinNum <- sub(pattern = "[0]+",
                        replacement = "",
                        x = substr(rteFileName, 1,5))

      subasinIndices <- c(subasinIndices,
                           paste("Sub_",
                                 subasinNum,
                                 sep = ""))
    }

  for (subasinLevelCatg in names(subasinLevelCatgs)) {

    subasinLevelParmList <- list()
    for (subasinLevelParmName in subasinLevelCatgs[[subasinLevelCatg]]) {
      subasinIndicesList <- list()
      for (subasinIndex in subasinIndices) {
        subasinIndicesList[[subasinIndex]] <- rangeList
        subasinLevelParmList[[subasinLevelParmName]] <- subasinIndicesList
      }
      input[[subasinLevelCatg]] <- subasinLevelParmList
    }
  }

  # Global parameters inside .bsn, .wwq, plant.dat
  globalCatgs <- list("plant" = kPlantParmNames,
                      "wwq"   = kWwqParmNames,
                      "bsn"   = kBsnParmNames)

  for (globalCatg in names(globalCatgs)) {
    globalParmList <- list()
    for (globalParm in globalCatgs[[globalCatg]]) {
      globalParmList[[globalParm]] <- rangeList
    }
    input[[globalCatg]] <- globalParmList
  }

  input$projectPath <- projectPath
  input
}
