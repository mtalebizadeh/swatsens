

getSubbasinNumberFromFileName <- function(fileName) {
  # Extracts subbasin number from pmf file names, format: e.g., pmf_8_PET.csv
  subNumber <- unlist(strsplit(fileName, "[_]"))[2]
  return(subNumber)
}


caclulateSACoeffs <- function(GSA_Object,
                              Y,
                              GSA_Type) {

  "src, srrc, morris, fast"

  if (GSA_Type == "morris") {
    GSA_Object <- sensitivity::tell(GSA_Object, y = Y)
    Mu_Sigma <- print(GSA_Object)
    print(Mu_Sigma)
    return(Mu_Sigma)
  }
  else if (GSA_Type == "src") {
    GSA_Object <- sensitivity::src(GSA_Object$X, y = Y, rank = FALSE,
                                   nboot = 0, conf = 0.95)
    SRC_Coeff <- as.data.frame(sensitivity:::print.src(GSA_Object))
    colnames(SRC_Coeff) <- c("SRCs")
    print(SRC_Coeff)
    return(SRC_Coeff)
  }
  else if (GSA_Type == "srrc") {
    GSA_Object <- sensitivity::src(GSA_Object$X, y = Y, rank = TRUE,
                                   nboot = 0, conf = 0.95)
    SRC_Coeff <- as.data.frame(sensitivity:::print.src(GSA_Object))
    colnames(SRC_Coeff) <- c("SRRCs")
    print(SRC_Coeff)
    return(SRC_Coeff)
  }else if (GSA_Type=="fast") {


    GSA_Object$X <- scale(x = GSA_Object$X,center = TRUE,scale = TRUE)
    Y = scale(x = Y,center = TRUE,scale = TRUE)
    GSA_Object <- sensitivity::tell(GSA_Object, y = Y)
    FAST99_Idx <- as.data.frame(sensitivity:::print.fast99(GSA_Object))
    colnames(FAST99_Idx) <- c("Main Efffect","Total Effect")
    print(FAST99_Idx)
    return(FAST99_Idx)

  }
  else {
    stop("Invalid sensitivity analysis method. Valid methods are: src, srrc, morris, fast")
  }
} # Function end
