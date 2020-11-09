# parmRange$rte$SPEX$Sub_1$low= -0.02 # CHCECK THIS FOR BUGS! #############

source('./R/genParmRange.R')
source('./R/getParmFileName.R')
source('./R/getParmValues.R')
source('./R/parmNames.R')
source('./R/setInAllHrus.R')
source('./R/writeParmValues.R')
source('./R/createGsaObject.R')

source('./R/runMonteCarlo.R')     # run Monte Carlo simulation


library("sensitivity")


# testing createGsaObject:
projectPath <- "C:/Users/myAcerPC2019/Documents/SWATSENSE/model/TxtInOut"
parmRange <- genParmRange(projectPath)
gsaType <- "src" # Available methods are: src, srrc, morris, fast

parmRange$hru$SLSUBBSN$Idx_1_1$low = 0.1
parmRange$hru$SLSUBBSN$Idx_1_1$up = 0.3


# parmRange$mgt$NMGT$Idx_1_1$low = -0.01
# parmRange$mgt$NMGT$Idx_1_1$up = 0.2

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

# Running Monte Carlo simulation using sampled parameters
runMonteCarlo(A, projectPath)

# Calculate SA coefficients
# THE FIRST TWO YEARS ARE NOT (WARM-UP) IN THE 'output.sub' file:



