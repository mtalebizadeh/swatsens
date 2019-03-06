
# Parameters inside .hru files (HRU level parameters):
kHruParmNames <- c("SLSUBBSN", "OV_N", "LAT_TTIME", "LAT_SED",
                   "SLSOIL", "CANMX", "ESCO", "EPCO",
                   "ERORGN", "ERORGP", "DEP_IMP", "SURLAG",
                   "R2ADJ")

# Parameters inside .mgt files (HRU level parameters):
kMgtParmNames <- c("CN2", "USLE_P")

# Parameters inside .gw files (HRU level parameters):
kGwParmNames <- c("GW_DELAY", "ALPHA_BF", "GWQMN", "GW_REVAP",
                  "REVAPMN", "RCHRG_DP", "GWSOLP", "LAT_ORGN",
                  "LAT_ORGP", "ALPHA_BF_D")

#Parameters inside .sol files (HRU level parameters):
kSolParmNames <- c("SOL_AWC", "SOL_K", "USLE_K")

# Parameters inside .rte files (Subasin level parameters):
kRteParmNames <- c("CH_K2", "SPCON", "SPEX", "PRF")

# Parameters inside .sub files (Subasin level parameters):
kSubParmNames <- c("CH_K1", "CH_N1")

# Parameters inside plant.dat files (global parameters):
kPlantParmNames <- c("BIO_E", "USLE_C")

# Parameters inside .wwq files (global parameters):
kWwqParmNames <- c("RHOQ", "AI1", "AI2")

# Parameters inside .bsn file (global parameters):
kBsnParmNames <- c("P_UPDIS", "PPERCO", "CMN",
                   "N_UPDIS", "NPERCO", "RSDCO")

# Parameter name to format string map
kParmName2FormatStringMap <- c(
  "SLSUBBSN" = "%16.3f",    # hru parameters
  "OV_N" = "%16.3f",
  "LAT_TTIME" = "%16.3f",
  "LAT_SED" = "%16.3f",
  "SLSOIL" = "%16.3f",
  "CANMX" = "%16.3f",
  "ESCO" = "%16.3f",
  "EPCO" = "%16.3f",
  "ERORGN" = "%16.3f",
  "ERORGP" = "%16.3f",
  "DEP_IMP" = "%16.0f",
  "SURLAG" = "%16.1f",
  "R2ADJ" = "%16.1f",
  "CN2" = "%16.2f",         # mgt parameters
  "USLE_P" = "%16.2f",
  "GW_DELAY" = "%16.4f",    # gw parameters
  "ALPHA_BF" = "%16.4f",
  "GWQMN" = "%16.4f",
  "GW_REVAP" = "%16.4f",
  "REVAPMN" = "%16.4f",
  "RCHRG_DP" = "%16.4f",
  "GWSOLP" = "%16.4f",
  "LAT_ORGN" = "%16.4f",
  "LAT_ORGP" = "%16.4f",
  "ALPHA_BF_D" = "%16.4f",
  "CH_K2" = "%14.3f",       # rte parameters
  "SPCON" = "%14.4f",
  "SPEX" = "%14.2f",
  "PRF" = "%14.2f",
  "CH_K1" = "%16.3f",       # subbasin parameters
  "CH_N1" = "%16.3f",
  "BIO_E" = "%7.2f",       # plant parameters
  "USLE_C" = "%6.4f",
  "RHOQ" = "%16.3f",        # wwq parameters
  "AI1" = "%16.3f",
  "AI2" = "%16.3f",
  "P_UPDIS" = "%16.3f",     # basin parameters
  "PPERCO" = "%16.3f",
  "CMN" = "%16.5f",
  "N_UPDIS" = "%16.3f",
  "NPERCO" = "%16.3f",
  "RSDCO" = "%16.3f")





