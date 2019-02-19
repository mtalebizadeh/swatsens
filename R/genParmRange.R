

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

  # Global parameters inside .bsn, .wwq files
  globalCatgs <- list("wwq"   = kWwqParmNames,
                      "bsn"   = kBsnParmNames)

  for (globalCatg in names(globalCatgs)) {
    globalParmList <- list()
    for (globalParm in globalCatgs[[globalCatg]]) {
      globalParmList[[globalParm]] <- rangeList
    }
    input[[globalCatg]] <- globalParmList
  }

  # Global plant parameters inside plant.dat
  plantTypes <- c()
  for (hruLevelFileName in hruLevelFileNames) {
    con <- file(file.path(projectPath, hruLevelFileName))
    firstLineInFile <- readLines(con)[1]
    firstLineSplit <-  unlist(strsplit(firstLineInFile, split = "Luse:"))[2]
    landUse <- regmatches(x = firstLineSplit,
                          m = regexpr(pattern = "[A-Z]+",
                                      text    = firstLineSplit))
    plantTypes <- c(plantTypes, landUse)
    close(con)
  }
  plantTypes <- unique(plantTypes)

  plant <- list()
  for (plantType in plantTypes) {
    plantTypeList <- list()
    for (kPlantParmName in kPlantParmNames) {
      plantTypeList[[kPlantParmName]] <- rangeList
    }
    plant[[plantType]] <- plantTypeList
  }
  input[["plant"]] <- plant
  input$projectPath <- projectPath
  input
}
