# kOutputSubParmNames <- c("SUB", "GIS", "MON", "AREA", "PRECIP", "SNOMELT",
#                          "PET", "ET", "SW", "PERC", "SURQ",
#                          "GW_Q", "WYLD", "SYLD", "ORGN", "ORGP", "NSURQ",
#                          "SOLP", "SEDP", "LATNO3", "GWNO3",
#                          "CHOLA", "CBODU", "DOXQ", "TNO3", "QTILE", "TVAP")

getAllOutputSubNames <- function(outputSubFile,
                                 skip) {
  # Returns vector of output parameter names inside 'output.sub' file

  conn <- file(outputSubFile, open = 'r')
  for (i in 1:skip) {
    readLines(conn,n = 1)
  }
  colNamesStr <- readLines(conn, n = 1)
  close(conn)
  parmRegex <- paste(kOutputSubParmNames, collapse = "|")
  # A dummy name is added to offset 'BIGSUB' in the first column
  return(c("dummy", unlist(stringr::str_match_all(colNamesStr, parmRegex))) )

}

getSubbasinsFromOutputDataframe <- function(outputDataframe,
                                            subColName = "SUB") {
  # Get the number of subbasins from outputDataframe
  subs = levels(outputDataframe[, subColName])
  return(subs)
}

getDateSequenceFromOutputDataframe <- function(outputDataframe,
                                               startDate,
                                               n_sub
                                               ) {
  # Creates date sequence from 'MON' column in output dataframe

  # Args:
  #   outputDataframe: Dataframe corresponding to output.sub file
  #   startDate: A string representing start date of simualation: "2003-01-01"
  #   n_sub: Number of subbasins
  #
  # Returns:
  #   a date.sequence covering the entire simulation period.
  ###############################################################
  MON_col = outputDataframe[,c('MON')]
  # left side of '.'is day number from start, e.g. 1.13020E+02 => day number: 1
  n_row = nrow(outputDataframe)
  dateSeq = seq.Date(from = as.Date(startDate),
                     by = "day",
                     length.out = n_row / n_sub)
  dateSeq_concat = c()
  n = length(dateSeq)
  for (i in 1: n) {
    dateSeq_concat = append(dateSeq_concat, rep(dateSeq[i], n_sub))
  }

  return(dateSeq_concat)
}
##########################################
extractOutput <- function(outputSubFile,
                          startDate,
                          skip,
                          outputVars,
                          subbasinFolderPath,
                          pmfFolderPath
                          ) {
  # Extracts outputs from output.sub file

  # Args:
  #   outputVars: A string vector containing output names in output.sub file
  #
  # Returns
  #########################################################
  if (!all(outputVars %in% getAllOutputSubNames(outputSubFile = outputSubFile,
                                                skip = skip))) {
    stop("not a valid output parameter in output.sub file")
  }


  # Load dataframe from output.sub file
  data <- read.table(file = outputSubFile, skip = skip+1,
                     colClasses = c("character","factor", "integer", "character",
                                    "numeric", "numeric",  "numeric", "numeric",
                                    "numeric", "numeric",  "numeric", "numeric",
                                    "numeric", "numeric",  "numeric", "numeric",
                                    "numeric", "numeric",  "numeric", "numeric",
                                    "numeric", "numeric",  "numeric", "numeric",
                                    "numeric", "numeric",  "numeric", "numeric"
                     ))

  names(data) <- getAllOutputSubNames(outputSubFile = outputSubFile, skip = skip)

  # create datesequence covering simulation period
  subs = getSubbasinsFromOutputDataframe(outputDataframe = data,
                                        subColName = "SUB")
  n_sub = length(subs)
  dateSeq_concat = getDateSequenceFromOutputDataframe(outputDataframe = data,
                                               startDate = startDate,
                                               n_sub = n_sub)
  # add a date column to data
  data$dateSeq_concat = dateSeq_concat

  # Extract output variables and append to files in subbasin and pmfs folder
  for (sub in subs) {
    for (v in outputVars) {

      outputVarData = subset.data.frame(data, SUB==sub, select = c("dateSeq_concat", v))
      # Transpose dataframe
      outputVarDataTransposed = as.data.frame(
        matrix(data = outputVarData[, v],
               nrow = 1,
               ncol = nrow(outputVarData)
               )
        )
      colnames(outputVarDataTransposed) <- outputVarData[, "dateSeq_concat"]

      # Appending simulated outputs to subbasin folder
      filePath = paste(subbasinFolderPath,
                       paste("/sub", "_", sub, '_', v, ".csv", sep=""),
                       sep = "")
      if (file.exists(filePath)) {
        write.table(outputVarDataTransposed, file = filePath ,append = TRUE,
                    quote = TRUE, sep = ",", dec = ".", row.names = FALSE,
                    col.names = FALSE)
      } else {
        write.table(outputVarDataTransposed, file = filePath ,append = TRUE,
                    quote = TRUE, sep = ",", dec = ".", row.names = FALSE,
                    col.names = TRUE)
      }

      # Calculate aggregate PMF (performance measure)
      pmfValue = mean(outputVarData[, v])
      pmfValue = data.frame(v = pmfValue)
      names(pmfValue) <- v

      # Appending PMF values to pmfs folder
      filePathPmf = paste(pmfFolderPath,
                       paste("/pmf", "_", sub, '_', v, ".csv", sep=""),
                       sep = "")
      if (file.exists(filePathPmf)) {
        write.table(pmfValue, file = filePathPmf ,append = TRUE,
                    quote = TRUE, sep = ",", dec = ".", row.names = FALSE,
                    col.names = FALSE)
      } else {
        write.table(pmfValue, file = filePathPmf ,append = TRUE,
                    quote = TRUE, sep = ",", dec = ".", row.names = FALSE,
                    col.names = TRUE)
      }

    }
  }
}

