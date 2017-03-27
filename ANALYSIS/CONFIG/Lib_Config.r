# =================================================================
#
#-- Report suite master
#
#-- Author: Peter Campbell-Burns, UKMON
#-- Version 1.0, 12/12/2015
#
#-- Shared under the Creative Common  Non Commercial Sharealike 
#   License V4.0 (www.creativecommons.org/licebses/by-nc-sa/4.0/)
#
#-- Version History
#  ----------------
#   Vers  Date          Note
#   1.1   09/02/2016    Changes to improve MacOS compatibility
#   1.0   12/12/2015    First release
#   1.1   08/03/2017    Revised file handling
#
# =================================================================

#-- Name of UFO catalogue file

Catalog = "J8"

#-- Switch to control wheter QA criteria are applied

Apply_QA = FALSE

#-- Source data file name (Value of NA trigers file picker dialogue)

SourceUnified    <-  "UKMON-all-unified.csv"   # Unified Obs File
SourceSingle     <-  "UKMON-all-single.csv"    # Single Obs File 

#-- Page sizing

Portrait = data.frame(
    otype=c("JPG","PDF"),
    width=c(870,6.5),
    height=c(1700,9.5),
    papr = "a4",
    row.names=1)

Landscape = data.frame(
    otype=c("JPG","PDF"),
    width=c(1900,9.5),
    height=c(1347,6.5),
    papr = "a4r",
    row.names=1)

#-- Timeline Plot intervals  (change to suit stream reporting)

SelectInterval    = 10 * 60 # in seconds
SelectIntervalSol = 0.01    # in degrees solar longitude

#-- Options for output
OutType  = NA       # Force dialogue
#OutType = "JPG"    # Force JPEG
#OutType = "PDF"    # Force PDF

#-- Analysis folders

WorkingDir     = paste(root,"/RWORKSPACE",sep="")        # R workspace for saved R environments
DataDir        = paste(root,"/DATA",sep="")              # Source meteor data
FuncDir        = paste(root,"/LIBRARY/FUNCTIONS",sep="") # Path to R report code modules
PlotDir        = paste(root,"/LIBRARY/PLOTS",sep="")     # Path to R report code modules
TabsDir        = paste(root,"/LIBRARY/TABLES",sep="")    # Path to R report code modules
RefDir         = paste(root,"/CONFIG",sep="")            # Path to Reference data (meteor lookup)
ReportDir      = paste(root,"/REPORTS",sep="")		       # Path to output report directory