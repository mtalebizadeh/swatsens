


readParmInFile <- function(fileLines, parmNameInSWAT) {
  # Reads a parameter value.
  #
  # Args:
  #   fileLines: A character vector containing input file lines, i.e., output of
  #       readLines() function.
  #   parmNameInSWAT: Parameter name as it appears in an SWAT input file
  #
  logicalVec <- grepl(pattern = parmNameInSWAT, fileLines)
  targetLine <- fileLines[logicalVec]
  parmValue <- unlist(strsplit(x = targetLine, split = "[|]"))[1]
  parmValue <- as.numeric(trimws(parmValue))

  return(parmValue)
}
