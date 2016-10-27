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
#   1.0   12/12/2015    First release
#
# =================================================================

#-- Switch to control wheter QA criteria are applied

Apply_QA = FALSE

#-- Source data file name (Value of NA trigers file picker dialogue)

#SourceUnified   ="EDMOND 5 v2 - Unified.csv"            # Source UFO Orbit UNIFIED data (path is DataDir below)
#SourceUnified   ="Unified.csv"                          # Source UFO Orbit UNIFIED data (path is DataDir below)
SourceUnified   = NA

#-- Page sizing

Portrait = data.frame(
    otype=c("JPG","PDF"),
    width=c(877,6.5),
    height=c(1745,9.5),
    papr = "a4",
    row.names=1)

Landscape = data.frame(
    otype=c("JPG","PDF"),
    width=c(1745,9.5),
    height=c(877,6.5),
    papr = "a4r",
    row.names=1)

#-- Timeline Plot intervals  (change to suit stream reporting)

SelectInterval    = 10 * 60 # in seconds
SelectIntervalSol = 0.01    # in degrees solar longitude

#-- Options for output
OutType = "JPG"
#OutType = "PDF"
#OutType = "CONSOLE"

#-- Filesystem parameters

root = "~/ANALYSIS"					 # Filesystem root (~ is users documents folder on Windows)

#-- Analysis folders

WorkingDir     = paste(root,"/RWORKSPACE",sep="")        # R workspace for saved R environments
DataDir        = paste(root,"/DATA",sep="")              # Source meteor data
FuncDir        = paste(root,"/LIBRARY/FUNCTIONS",sep="") # Path to R report code modules
PlotDir        = paste(root,"/LIBRARY/PLOTS",sep="")     # Path to R report code modules
TabsDir        = paste(root,"/LIBRARY/TABLES",sep="")    # Path to R report code modules
RefDir         = paste(root,"/CONFIG",sep="")            # Path to Reference data (meteor lookup)
ReportDir      = paste(root,"/REPORTS",sep="")		       # Path to output report directory