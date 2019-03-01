
# testing createGsaObject:
projectPath <- "E:/Sensitivity_Projects/SWATExp/example/TxtInOut"
parmRange <- genParmRange(projectPath)
gsaType <- "FaSt"
parmRange$hru$HRU_FR$Idx_1_1$low = 0.1
parmRange$hru$HRU_FR$Idx_1_1$up = 0.3

parmRange$mgt$NMGT$Idx_1_1$low = -0.01
parmRange$mgt$NMGT$Idx_1_1$up = 0.2

parmRange$gw$GW_DELAY$Idx_1_1$low = -0.02
parmRange$gw$GW_DELAY$Idx_1_1$up = 0.02


GSA <- createGsaObject(parmRange = parmRange,
                       gsaType = gsaType,
                       rangeType = "rel")


str_test <- "ddd WWSS SFFome other info"
pattern <- "[A-Z]+"

aa <- regmatches(x = str_test,m = regexpr(pattern = pattern,text = str_test))

#######################


######################
# Testing getParmValueFromFileLines
con = file("E:/Sensitivity_Projects/SWATExp/example/TxtInOut/plant.dat")
fileLines <- readLines(con)
parmNameInSWAT <- "WETN.USLE_C"
getParmValueFromFileLines(fileLines, parmNameInSWAT)
close(con)
###################






