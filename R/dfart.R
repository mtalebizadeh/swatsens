#a <- c(1,1,1,3,3,3,5,6)
a <- c("a","a","a","b","b","d","d","d")
b <- c(43,23,11,65,43,21,46,53)
myDF <- data.frame(Name=a, Income=b,stringsAsFactors = F)

aggregate(x = subset(x = myDF,select = c("Income")),
          by = list(fileList=myDF$Name),
          FUN = function(x) sum(x))


projectPath <- "/home/mk/Documents/swat_sens/SWAT/TxtInOut"

A <- genParmRange(projectPath)
parmNameInSWAT <- "SHALLST"
parmRangeList <- setInAllHrus(parmRangeList = a,
             parmNameInSWAT = parmNameInSWAT,
             low = 0,
             up = 5)

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


parmNames <- names(unlist(parmRange))
parmName = parmNames[startsWith(parmNames,"hru")][1000]


fileName = getParmFileName(parmName)
fileName
parmName







