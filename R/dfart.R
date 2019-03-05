
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
parmName <- "plant.OATS.USLE_C"
getParmValueFromFileLines(fileLines, parmName)
close(con)
###################
# Testing getParmValues
parmNames <- c("hru.HRU_FR.Idx_1_1", "hru.SLSUBBSN.Idx_1_1",
                 "mgt.NMGT.Idx_1_1", "mgt.IGRO.Idx_1_1",
                 "gw.GW_DELAY.Idx_1_1", "gw.SHALLST.Idx_1_1",
#                 "sol.SOL_K.Idx_1_4", "sol.USLE_K.Idx_4_1",
                  "plant.FRST.BIO_E", "plant.ORCD.USLE_C",
                  "sub.CH_K1.Sub_2","rte.SPCON.Sub_4",
                  "bsn.P_UPDIS", "wwq.RHOQ"
                   )
projectPath <- "E:/Sensitivity_Projects/SWATExp/example/TxtInOut"
getParmValues(parmNames, projectPath)




