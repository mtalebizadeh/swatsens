
runMonteCarlo <- function(parmDataFrame,
                          projectPath,
                          outputSubFile="../model/TxtInOut/output.sub",
                          startDate="2003-01-01",
                          skip=8,
                          outputVars = c("PET", "PRECIP", "ORGN", "SYLD"),
                          subbasinFolderPath = "C:/Users/myAcerPC2019/Documents/SWATSENSE/outputs/subs/",
                          pmfFolderPath = "C:/Users/myAcerPC2019/Documents/SWATSENSE/outputs/pmfs/",
                          exe_fileName = "rev670_64rel.exe"
                          ) {

  n_row = nrow(parmDataFrame)
  for (row_num in 1:5) {

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



