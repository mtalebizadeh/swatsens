

writeParam <- function(txtInOut, parmVector) {


}

parmName2fileName <- function(parmName) {
  # takes parameter name and output file name
  # parameter names should be appended ".subbasinNumb_hruNum"


  # Parameters inside .hru files:
  hruParms <- C("HRU_FR", "SLSUBBSN", "HRU_SLP", "OV_N",
                "LAT_TTIME", "LAT_SED", "SLSOIL", "CANMX",
                "ESCO", "EPCO", "RSDIN", "ERORGN",
                "ERORGP", "POT_FR", "FLD_FR", "RIP_FR",
                "POT_TILE", "POT_VOLX", "POT_VOL", "POT_NSED",
                "POT_NO3L", "DEP_IMP", "EVPOT", "DIS_STREAM",
                "CF", "CFH", "CFDEC", "SED_CON",
                "ORGN_CON", "ORGP_CON", "SOLN_CON", "SOLP_CON",
                "POT_SOLP", "POT_K", "N_REDUC", "N_LAG",
                "N_LN", "N_LNCO", "SURLAG", "R2ADJ"
                )

  # Parameters inside .mgt files:
  mgtParms <- c("NMGT", "IGRO", "PLANT_ID", "LAI_INIT",
                "BIO_INIT", "PHU_PLT", "BIOMIX", "CN2",
                "USLE_P", "BIO_MIN", "FILTERW", "IURBAN",
                "URBLU", "IRRSC", "IRRNO", "FLOWMIN",
                "DIVMAX", "FLOWFR", "DDRAIN", "TDRAIN",
                "GDRAIN", "NROT")

  # Parameters inside .gw files:
  gwParms <- c("SHALLST", "DEEPST", "GW_DELAY", "ALPHA_BF",
               "GWQMN", "GW_REVAP", "REVAPMN", "RCHRG_DP",
               "GWHT", "GW_SPYLD", "SHALLST_N", "GWSOLP",
               "HLIFE_NGW", "LAT_ORGN", "LAT_ORGP", "ALPHA_BF_D")

  # Parameters inside .sub files:
  subParms <- c()

  #Parameters inside .sol files:
  solParms <- c("HYDGRP", "SOL_ZMX", "ANION_EXCL", "SOL_CRK",
                "SOL_Z", "SOL_BD", "SOL_AWC", "SOL_K",
                "SOL_CBN", "SOL_CLAY", "SOL_SILT", "SOL_SAND",
                "SOL_ROCK", "SOL_ALB", "USLE_K", "SOL_EC",
                "SOL_CAL", "SOL_PH"
                )

  # Parameters inside plant.dat file:
  plantParms <- c()






}





