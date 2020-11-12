swatsens quick start manual
================


Introduction
------------

swatsens is a package in R for performing sensitivity and model performance analysis for the SWAT model.The package is part of land and water resources management studies at USDA-ARS Grazinglands Research Laboratory.

How it works
--------------

<p>
1) swatsens automatically extracts SWAT model information from TextInOut folder.
To achieve this, users are required to make a backup of TextInOut project (see "backUpTextInOutPath" in SA section) and provide its path along with other set of
user-supplied inputs.
</p>
<p>
2) After setting the inputs, "genParmRange" function with "backUpTextInOutPath" as
its argument is called to generate a list containing empty ranges of SWAT model
parameters. Using this generated list, user can set uncertainty range for different
SWAT model parameters.
</p>
<p>
3) Once, the range of parameter uncertainties are set, "createGsaObject" function
is called to create a GSA list containing samples from the ranges of uncertain parameters and other sensitivity analysis (SA) settings.
</p>
<p>
4) "runMonteCarlo" function is called to run Monte Carlo simulation using the generated samples and save the timeseries of different SWAT outputs,
located inside SWATS's "output.sub" file, as well as a performance measure (current version of swatsens only supports "mean" as performance measure).
</p>
<p>
At last, the program simply loops through performance measure files and SA coeeficients are calculated and save inside "gsa_output" folder.
</p>


Steps for performing SA
-----------------------
``` r
# 1) Setting required inputs:
     # original TextInout (used for reading SWAT parameters)
     backUpTextInOutPath <- "D:/backUpTxtInOut"
    
     # TextInOut Folder (used for performing MC simulations)
     textInOutPath <- "D:/TxtInOut"
     
     # SWAT executable file inside name TextInOut folder
     exe_fileName = "rev670_64rel.exe"
    
     # Path to output.sub file inside TextInOut folder
     outputSubFile= "D:/TxtInOut/output.sub"

     # Output folders where performance metric (i.e. mean), SA coeffs, and timeseries
     # are stored inside pmfs, gsa_outputs, and subs are stored, respectively
     pmfFolderPath = "D:/outputs/pmfs"
     folder_path_GSA_Outputs <- "D:/outputs/gsa_output"
     subbasinFolderPath = "D:/outputs/subs"
    
     # Beginning year of simulation as it appears inside "file.cio"
     # Please make sure "IDAF" and "IDAL" values are set to 0 inside "file.cio"  
     startDate="2003-01-01"
     outputVars = c("PET", "PRECIP", "ORGN", "SYLD")
     gsaType <- "src" # Available methods are: "src", "srrc", "morris", "fast"
     n = 1000         # Number of generated samples

# 2) Generating range of parametrs and setting relative uncertainty ranges
     parmRange <- genParmRange(backUpTextInOutPath)
     
     parmRange$gw$GW_DELAY$Idx_1_1$low = -0.02 # i.e., lower uncertainty: default*(1 - 0.02)
     parmRange$gw$GW_DELAY$Idx_1_1$up = 0.02 # i.e., upper uncertainty: default*(1 + 0.02)
     
     parmRange$hru$SLSUBBSN$Idx_1_1$low = 0.1
     parmRange$hru$SLSUBBSN$Idx_1_1$up = 0.3

     parmRange$bsn$P_UPDIS$low = -0.02
     parmRange$bsn$P_UPDIS$up = 0.02
  
     parmRange$wwq$RHOQ$low = -0.2
     parmRange$wwq$RHOQ$up = 0.2
      
     parmRange$plant$FRST$BIO_E$low = -0.2
     parmRange$plant$FRST$BIO_E$up = 0.2
     
# 3) Create GSA object
     GSA <- swatsens::createGsaObject(parmRange = parmRange,
                       gsaType = gsaType,
                       rangeType = "rel", n = n)

# 4) Run Monte Carlo simulations and save model outputs and performance measure
     swatsens::runMonteCarlo(parmDataFrame = GSA$X,
              projectPath = textInOutPath,
              outputSubFile= outputSubFile,
              startDate=startDate,
              skip=8,
              outputVars = outputVars,
              subbasinFolderPath = subbasinFolderPath,
              pmfFolderPath = pmfFolderPath,
              exe_fileName = exe_fileName)
  
# 5) Calculating SA coefficients for different variables inside "output.sub" file  
  for (f in list.files(pmfFolderPath) ) {

  y = read.table(paste(pmfFolderPath, "/", f, sep=""), header = TRUE)
  SACoeffs <- swatsens::caclulateSACoeffs(GSA_Object = GSA,
                                Y = y,
                                GSA_Type = gsaType)
  print(f)
  write.table(SACoeffs,
              paste(folder_path_GSA_Outputs,
                    "/", "sub_",swatsens::getSubbasinNumberFromFileName(f),
                    "_", names(y),
                    ".txt", sep = ""),
              sep = "\t")
}
```
