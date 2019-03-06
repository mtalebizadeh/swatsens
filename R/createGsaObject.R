

createGsaObject <- function(parmRange, gsaType, rangeType = "rel", ...) {
  # Creates a GSA object using uncertainty ranges and a selected GSA method.
  #
  # Args:
  #   parmRange: a List object contaning lower and upper limits. Use 'genParmRange'
  #              function for generating a template list and then set range limits.
  #   gsaType: Name of sensitivity analysis method. Available methods are:
  #            "src", "srrc", "morris", "fast".
  #   rangeType: "rel" or "abs" for relative and absolute range values, respectively.
  #   ... : method-specific parameter. Default values are used if not set. See
  #          'sensitivity' package documentation for details.
  #
  # Returns:
  #   A GSA object containing parameter samples and sensitivity analysis setting.

  # Extracting uncertain parameter name
  parmRangeInHrus <- parmRange[!(names(parmRange) %in% c("projectPath"))] # removes projectPath
  parmRangeVector <- unlist(parmRangeInHrus)
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
        names(lowerLimit) <- parmName
        names(upperLimit) <- parmName
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

  # Use lower, upper, and default values (accessed using readParm function)
  # Multiplying lower and upper fractions to calculate lower and upper limits
  if (rangeType == "rel") {
    for (parmName in names(lowerLimits)) {
      lowerLimits[parmName] <- (lowerLimits[parmName] + 1) *
                                getParmValues(parmName, parmRange$projectPath)
      upperLimits[parmName] <- (upperLimits[parmName] + 1) *
                                getParmValues(parmName, parmRange$projectPath)
      }
  }

  SA.Parms <- list(...)
  #SA.Parms <- list()

  SA.ParmNames <- names(SA.Parms)
  if (tolower(gsaType) == "src" ||
      tolower(gsaType) == "srrc") {

    if ("n" %in% SA.ParmNames) {
      n <- SA.Parms[["n"]]
    } else {
        n <- 1000
        warning(paste("Default value of 1000 is used as sample number!\n",
                      "To use a different number (e.g. 2000) set n=2000"))
    }

    parmSamples <- as.data.frame(matrix(ncol = length(lowerLimits),
                                        nrow = n))
    sampledParmNames <- names(lowerLimits)
    names(parmSamples) <- sampledParmNames
    for (sampledParmName in sampledParmNames) {
      parmSamples[[sampledParmName]] <- runif(n,
                                              min = lowerLimits[sampledParmName],
                                              max = upperLimits[sampledParmName]
                                              )
    }
    gsaObject <- list(X = parmSamples)

  } else if (tolower(gsaType) == "morris") {
    if ("r" %in% SA.ParmNames) {
      r <- SA.Parms[["r"]]
    } else {
      r <- 15
    }
    if ("levels" %in% SA.ParmNames) {
      levels <- SA.Parms[["levels"]]
    } else {
      levels <- 8
    }
    gsaObject <- sensitivity::morris(model = NULL,
                                     factors = names(lowerLimits),
                                     r = r,
                                     design = list(type = "oat",
                                                   levels = levels,
                                                   grid.jump = 1),
                                     binf = lowerLimits,
                                     bsup = upperLimits,
                                     scale = TRUE)

    gsaObject$X <- as.data.frame(gsaObject$X)

  } else if (tolower(gsaType) == "fast") {
    if ("n" %in% SA.ParmNames) {
      n <- SA.Parms[["n"]]
    } else {
      n <- 500
      warning(paste("Default value of 500 is used as sample number!\n",
                    "To use a different number (e.g. 1000) set n=1000"))
    }

    limitList <- list()
    for (parmName in names(lowerLimits)) {
      limitList[[parmName]] <- list(min = lowerLimits[parmName],
                                    max = upperLimits[parmName])
    }

    gsaObject <- sensitivity::fast99(model = NULL,
                                     factors = names(lowerLimits),
                                     n = n,
                                     M = 4,
                                     q = rep("qunif", length(lowerLimits)),
                                     q.arg = limitList)
  }

  return(gsaObject)
}







