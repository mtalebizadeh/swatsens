swatsens quick start manual
================


Introduction
------------

swatsens is a package in R for performing sensitivity and model performance analysis for the SWAT model.The package was primarily developed for USDA-ARS Grazinglands Research Laboratory.

Example folder
--------------

An example folder containing an APEX project and other inputs is available for users to test the package. The rest of this manual provides details of implementing an SA project using the accompanying example folder which can be created through a call to:

``` r
# Creating a copy of tutorial folder inside the working directory
  parapex::getExampleFolder()
```

Steps for performing SA
-----------------------

After loading parapex and generating a copy of the example folder, the following four steps, described in the next sections should be followed for performing SA.

``` r
# 1) Generating a list object with a predefined structure compatible to APEXSENSUN:
     Input <- parapex::inputGen()

# 2) Setting the required inputs (e.g. uncertainty boubds, SA method, sample size, ...)
  #
  # Setting uncertainty bounds:
    Input$APEX_PARM$Root_growth_soil[1]=1.1
    Input$APEX_PARM$Root_growth_soil[2]=1.20

    Input$APEX_PARM$Soil_water_limit[1]=0
    Input$APEX_PARM$Soil_water_limit[2]=1

    Input$APEX_PARM$Soil_evap_coeff[1]=1.5
    Input$APEX_PARM$Soil_evap_coeff[2]=2.5

    Input$APEX_PARM$Soil_evap_plant_cover[1]=0
    Input$APEX_PARM$Soil_evap_plant_cover[2]=0.5

    Input$APEX_PARM$Runoff_CN_int_abs[1]=0.05
    Input$APEX_PARM$Runoff_CN_int_abs[2]=0.4

    Input$APEX_PARM$Max_rain_intercept[1]=0
    Input$APEX_PARM$Max_rain_intercept[2]=15

    Input$APEX_PARM$Rain_intercept_coeff[1]=0.05
    Input$APEX_PARM$Rain_intercept_coeff[2]=0.3

    Input$APEX_PARM$Microbial_top_soil_coeff[1]=0.1
    Input$APEX_PARM$Microbial_top_soil_coeff[2]=1

    Input$APEX_PARM$Microbial_decay_coeff[1]=0.5
    Input$APEX_PARM$Microbial_decay_coeff[2]=1.5
  
  # SA method and sample size:
    Input$GSA_Type <- "FAST99"
    Input$sample_size = 1000

# 3) Performing Monte Carlo simulation using the setting Input:
     GSA <- parapex::MC4APEX(Input)
    
# 4) Calculation of performance matrix:
     Input$func_type <- "MEAN"
     perfMat <- parapex::perfMatrix(Input)
     
# 5) Calculation of sensitivity indices:
     SA <- parapex::SA4APEX(GSA, perfMat)
```

APENDIX
-------

This section provides 4 main tables containing the name of different parameters and their description.

                                                                         |


