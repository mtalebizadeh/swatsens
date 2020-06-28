

# parmRange$rte$SPEX$Sub_1$low= -0.02 # CHCECK THIS FOR BUGS! #############

source('./R/genParmRange.R')
source('./R/getParmFileName.R')
source('./R/getParmValues.R')
source('./R/parmNames.R')
source('./R/setInAllHrus.R')
source('./R/writeParmValues.R')
source('./R/createGsaObject.R')


library("sensitivity")


# testing createGsaObject:
projectPath <- "C:/Users/myAcerPC2019/Documents/SWATSENSE/model/TxtInOut"
parmRange <- genParmRange(projectPath)
gsaType <- "fast" # Available methods are: src, srrc, morris, fast
parmRange$hru$HRU_FR$Idx_1_1$low = 0.1
parmRange$hru$HRU_FR$Idx_1_1$up = 0.3

parmRange$mgt$NMGT$Idx_1_1$low = -0.01
parmRange$mgt$NMGT$Idx_1_1$up = 0.2

parmRange$gw$GW_DELAY$Idx_1_1$low = -0.02
parmRange$gw$GW_DELAY$Idx_1_1$up = 0.02
# #
# parmRange$rte$SPEX$Sub_1$low= -0.02 # CHCECK THIS FOR BUGS!
# parmRange$rte$SPEX$Sub_1$up = 0.02
#
parmRange$bsn$P_UPDIS$low = -0.02
parmRange$bsn$P_UPDIS$up = 0.02
#
parmRange$wwq$RHOQ$low = -0.2
parmRange$wwq$RHOQ$up = 0.2

parmRange$plant$FRST$BIO_E$low = -0.2
parmRange$plant$FRST$BIO_E$up = 0.2


GSA <- createGsaObject(parmRange = parmRange,
                       gsaType = gsaType,
                       rangeType = "rel")

A <- GSA$X


######################
# Testing getParmValueFromFileLines (reads parm value from a single file)
con = file("E:/Sensitivity_Projects/SWATSENS/example/TxtInOut/plant.dat")
fileLines <- readLines(con)
parmName <- "plant.OATS.USLE_C" #Parm name according to SWATSENS
getParmValueFromFileLines(fileLines, parmName)
close(con)
###################
# Testing getParmValues (read values from a vector of parm files!)
parmNames <- c("hru.HRU_FR.Idx_1_1", "hru.SLSUBBSN.Idx_1_1",
                 "mgt.NMGT.Idx_1_1", "mgt.IGRO.Idx_1_1",
                 "gw.GW_DELAY.Idx_1_1", "gw.SHALLST.Idx_1_1",
                  "plant.FRST.BIO_E", "plant.ORCD.USLE_C",
                  "sub.CH_K1.Sub_2","rte.SPCON.Sub_4",
                  "bsn.P_UPDIS", "wwq.RHOQ"
                   )

projectPath <- "E:/Sensitivity_Projects/SWATSENS/example/TxtInOut"
getParmValues(parmNames, projectPath)
######################
#######
# Testing writeParmValues function
parmValues <- c("hru.OV_N.Idx_1_1" = 0.555 , "hru.SLSUBBSN.Idx_1_1" = 80.80,
               "mgt.CN2.Idx_1_1" = 70, "mgt.USLE_P.Idx_1_1" = 2.3,
               "gw.GW_DELAY.Idx_1_1" = 88.2, "gw.ALPHA_BF.Idx_1_1" = 0.66,
               "rte.CH_K2.Idx_1_1" = 69, "rte.SPEX.Idx_1_1" = 0.66,
               "plant.AGRL.BIO_E" = 69.3, "plant.HAY.USLE_C" = 0.1,
               "sub.CH_K1.Sub_1" = 160,"sub.CH_N1.Sub_1" = 0.99,
               "bsn.P_UPDIS" = 50 , "wwq.RHOQ" = 5
               )
projectPath <- "E:/Sensitivity_Projects/SWATSENS/TestPrj/TxtInOut"
writeParmValues(parmValues = parmValues,projectPath = projectPath)








