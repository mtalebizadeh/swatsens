

createGsaObject <- function(parmRange, gsaType, ...) {
  # Creates a GSA object using uncertainty ranges and a selected GSA method.
  #
  # Args:
  #   parmRange: a List object contaning lower and upper limits. Use 'genParmRange'
  #              function for generating a template list and then set range limits.
  #   gsaType: Name of sensitivity analysis method. Available methods are:
  #            "src", "srrc", "morris", "fast".
  #   ... : method-specific parameter. Default values are used if not set. See
  #          'sensitivity' package documentation for details.
  #
  # Returns:
  #   A GSA object containing parameter samples and sensitivity analysis setting.

  projectPath <- "/home/mk/Documents/swat_sens/SWAT/TxtInOut"
  parmRange <- genParmRange(projectPath)

  parmRange$hru$HRU_FR$Idx_1_1$low = 0
  parmRange$hru$HRU_FR$Idx_1_1$up = 34

  parmRange$mgt$NMGT$Idx_1_1$low = 6
  parmRange$mgt$NMGT$Idx_1_1$up = 44

  parmRange$gw$GW_DELAY$Idx_1_1$low = 40
  parmRange$gw$GW_DELAY$Idx_1_1$up = 40

  # Extracting uncertain parameter names
  parmRangeVector <- unlist(parmRange)
  parmNames <- names(parmRangeVector)[endsWith(names(parmRangeVector),
                                               ".low")]
  parmNames <- unlist(strsplit(parmNames, ".low"))
  lowerLimits <- c()
  upperLimits <- c()
  for (parmName in parmNames) {
    lowerLimit <- parmRangeVector[paste(parmName, ".low", sep = "")]
    upperLimit <- parmRangeVector[paste(parmName, ".up" , sep = "")]
    if (!is.na(lowerLimit) &&
        !is.na(upperLimit)) {
      if (upperLimit > lowerLimit) {
        lowerLimits <- c(lowerLimits, lowerLimit)
        upperLimits <- c(upperLimits, upperLimit)
      } else {
        stop(paste("Upper limit should always be larger than the lower limit!\n"),
                   "Please correct the limits of ",
                    parmName,
                    " parameter.",
                    sep = "")
      }
    }
  }
}




