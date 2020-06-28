

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
  uncertaintyLimits <- getUncertaintyLimits(parmRange)

  SA.Parms <- list(...)
  SA.ParmNames <- names(SA.Parms)
  if (tolower(gsaType) == "src" ||
      tolower(gsaType) == "srrc") {
    gsaObject <- createSrcGsaObject(uncertaintyLimits, SA.Parms)
  } else if (tolower(gsaType) == "morris") {
    gsaObject <- createMorrisGsaObject(uncertaintyLimits, SA.Parms)
  } else if (tolower(gsaType) == "fast") {
    gsaObject <- createFastGsaObject(uncertaintyLimits, SA.Parms)
  } else {
    stop("Not a valid sensitivity analysis method!")
  }
  return(gsaObject)
}

createSrcGsaObject <- function(uncertaintyLimits, SA.Parms) {

  SA.ParmNames <- names(SA.Parms)
  if ("n" %in% SA.ParmNames) {
    n <- SA.Parms[["n"]]
  } else {
    n <- 1000
    warning(paste(
      "Default value of 1000 is used as sample number!\n",
      "To use a different number (e.g. 2000) set n=2000"))
  }
  lowerLimits <- uncertaintyLimits[["lowerLimits"]]
  upperLimits <- uncertaintyLimits[["upperLimits"]]
  parmSamples <- as.data.frame(
    matrix(ncol = length(lowerLimits),
    nrow = n))

  sampledParmNames <- names(lowerLimits)
  names(parmSamples) <- sampledParmNames
  for (sampledParmName in sampledParmNames) {
    parmSamples[[sampledParmName]] <- runif(
      n,
      min = as.numeric(lowerLimits[sampledParmName]),
      max = as.numeric(upperLimits[sampledParmName])
    )
  }
  gsaObject <- list(X = parmSamples)
  return(gsaObject)
}

createMorrisGsaObject <- function(uncertaintyLimits, SA.Parms) {

  SA.ParmNames <- names(SA.Parms)
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
  lowerLimits <- uncertaintyLimits[["lowerLimits"]]
  upperLimits <- uncertaintyLimits[["upperLimits"]]
  gsaObject <- sensitivity::morris(
    model = NULL,
    factors = names(lowerLimits),
    r = r,
    design = list(type = "oat",
    levels = levels,
    grid.jump = 1),
    binf = as.numeric(lowerLimits),
    bsup = as.numeric(upperLimits),
    scale = TRUE)

  gsaObject$X <- as.data.frame(gsaObject$X)
  return(gsaObject)
}

createFastGsaObject <- function(uncertaintyLimits, SA.Parms) {

  SA.ParmNames <- names(SA.Parms)
  if ("n" %in% SA.ParmNames) {
    n <- SA.Parms[["n"]]
  } else {
    n <- 500
    warning(
      paste("Default value of 500 is used as sample number!\n",
            "To use a different number (e.g. 1000) set n=1000"))
  }
  lowerLimits <- uncertaintyLimits[["lowerLimits"]]
  upperLimits <- uncertaintyLimits[["upperLimits"]]
  limitList <- list()
  for (parmName in names(lowerLimits)) {
    limitList[[parmName]] <- list(
      min = as.numeric(lowerLimits[parmName]),
      max = as.numeric(upperLimits[parmName]))
  }

  gsaObject <- sensitivity::fast99(
    model = NULL,
    factors = names(lowerLimits),
    n = n,
    M = 4,
    q = rep("qunif", length(lowerLimits)),
    q.arg = limitList)
  return(gsaObject)
}

getUncertaintyLimits <- function(parmRange, rangeType = "rel") {
  # Gets lower and upper uncertainty limits.
  #
  # Args:
  #   Input template (output of 'getParmRange' function).
  #   rangeType: "rel" or "abs" for relative and absolute, respectively.
  #
  # Returns: A named list object containing lower and upper limits.

  parmNames <- getUncertainParmNames(parmRange)
  lowerLimits <- c()
  upperLimits <- c()
  for (parmName in parmNames) {
    lowerLimit <- unlist(parmRange)[
      paste(parmName, ".low", sep = "")]
    upperLimit <- unlist(parmRange)[
      paste(parmName, ".up" , sep = "")]
    if (!is.na(lowerLimit) &&
        !is.na(upperLimit)) {
      if (upperLimit > lowerLimit) {
        names(lowerLimit) <- parmName
        names(upperLimit) <- parmName
        lowerLimits <- c(lowerLimits, lowerLimit)
        upperLimits <- c(upperLimits, upperLimit)
      } else {
        stop(
          paste(
            "Upper limit should always be larger than the lower limit!\n"),
            "Please correct the limits of ",
             parmName,
             " parameter.",
             sep = "")
      }
    }
  }

  if (rangeType == "rel") {
    for (parmName in names(lowerLimits)) {

      lowerLimits[parmName] <- (as.numeric(lowerLimits[parmName]) + 1) *
        getParmValues(parmName, parmRange$projectPath)

      upperLimits[parmName] <- (as.numeric(upperLimits[parmName]) + 1) *
        getParmValues(parmName, parmRange$projectPath)

    }
  }
  uncertaintyLimits <- list(
    lowerLimits = lowerLimits,
    upperLimits = upperLimits)
}

getUncertainParmNames <- function(parmRange) {
  # removing projectPath ...
  parmRanges<- parmRange[!(names(parmRange) %in% c("projectPath"))]
  parmRangeVector <- unlist(parmRanges)
  parmNames <- names(parmRangeVector)[endsWith(
    x = names(parmRangeVector),
    suffix = ".low")]
  parmNames <- unlist(strsplit(parmNames, ".low"))
  return(parmNames)
}



