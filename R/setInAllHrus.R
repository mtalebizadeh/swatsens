


setInAllHrus <- function(parmRangeList, parmNameInSWAT, low, up) {
  # Sets lower and upper limit ratios in all hrus.

  # Args:
  #   parmNameInSWAT: parameter name in an input file (.hru, .mgt, .gw, or .sol)
  #   parmRangeList: a list containing lower and upper limit ratios. i.e.,
  #                  output of genParmRange function.
  #
  # Returns:
  #   Sets the lower and upper limit ratios for a specific parameter.
  #
  ##############################################################################
  if (low >= up) {
    stop("Lower limit should be less than upper limit!")
  }

  # Determining parameter type, i.e., hru, mgt, gw, sol
  if (parmNameInSWAT %in% kHruParmNames) {
    parmType <- "hru"
  } else if (parmNameInSWAT %in% kMgtParmNames) {
    parmType <- "mgt"
  } else if (parmNameInSWAT %in% kGwParmNames) {
    parmType <- "gw"
  } else if (parmNameInSWAT %in% kSolParmNames) {
    parmType <- "sol"
  } else {
    stop("Not a valid parameter name!")
  }

  for (subAndHru in names(parmRangeList[[parmType]][[parmNameInSWAT]])) {

    parmRangeList[[parmType]][[parmNameInSWAT]][[subAndHru]][["low"]] = low
    parmRangeList[[parmType]][[parmNameInSWAT]][[subAndHru]][["up"]] = up
  }

  return(parmRangeList)
}
