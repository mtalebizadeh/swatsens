
runMonteCarlo <- function(parmDataFrame,
                          projectPath,
                          outputSubFile,
                          startDate,
                          skip,
                          outputVars,
                          subbasinFolderPath,
                          pmfFolderPath,
                          exe_fileName
                          ) {

  n_row = nrow(parmDataFrame)
  for (row_num in 1:n_row) {

    # write parameters
    parmValues <- unlist(parmDataFrame[row_num,])
    writeParmValues(parmValues = parmValues, projectPath = projectPath)

    # run .exe
    pwd <- getwd()
    setwd(projectPath)
    print(getwd())
    system(exe_fileName)
    setwd(pwd)

    # extract outputs and write pmf and sub files
    extractOutput(outputSubFile = outputSubFile,
                  startDate = startDate,
                  skip = skip,
                  outputVars = outputVars,
                  subbasinFolderPath = subbasinFolderPath,
                  pmfFolderPath = pmfFolderPath
    )
  }
}



