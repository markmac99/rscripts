#=============================================================================
#
#-- Author: P Campbell-Burns, UKMON
#
#
#-- Description:
#
#   This script runs only the QA_FILTER and allows a preview of the number of
#   records dropped from processing by the current filter settings
#
#   
#-- Version history
#
#   Vers  Date          Notes
#   ----  ----          -----
#   1.1   09/02/2016    Moved root path from config file to improve MacOS compatibility
#   1.0   03/12/2016    First release
#
#=============================================================================

cat("Reporting started",format(Sys.time(), "%a %b %d %Y %H:%M:%S"))

#-- Filesystem parameters

root = "~/ANALYSIS"					 # Filesystem root (~ is users documents folder on Windows)

# Initialise environment variables and common functions

  source(paste(root,"/ANALYSIS/CONFIG/Lib_QA.r", sep="")) 
  source(paste(root,"/ANALYSIS/CONFIG/Lib_Config.r", sep=""))
  source(paste(FuncDir,"/common_functions.r",sep=""))

  cat("\n",
      "Output type:       ",OutType,"\n",
      "QA filter enabled: ",Apply_QA,"\n\n",sep="")
  
# Set the R working directory (this is where R saves its environment)

    setwd(WorkingDir)
  
# Read UNIFIED CSV file created by UFO Orbit (all columns are read) and standardise data

    mt <- read_ufo()
    rows_read <- nrow(mt)
    if (rows_read == 0) {
        stop("No data in input file")
    } else {
    
        cat(paste("*** Rows read from inpuf file",as.character(rows_read),"\n"))
    
    # Select which stream / year to process
    
        stream <- get_stream(mt)
        SelectYr <- get_year(mt)
    
    #= Extract stream details
    
        SelectStream = stream[1,]
        Streamname   = stream[2,]

    # Get UNIFIED and Single observations
    
        mu <- filter_stream(mt, mstream=SelectStream, myr=SelectYr, mtype="UNIFIED")
    
        if (nrow(mu) == 0) {
            stop("No UNIFIED observations were found in the input data")
            } else {
        
        # Apply Quality Criteria
              
            mu <- filter_apply_qa(mu)
            
            cat("Summary of filtering:\n")
            cat("=====================\n")
            cat(paste("Fail: QA_dGP ",   nrow(mt[mt$X_dGP  > QA_dGP,]), "rows\n"))
            cat(paste("Fail: QA_QA  ",   nrow(mt[mt$X_QA   < QA_QA,]),  "rows\n"))
            cat(paste("Fail: QA_dv12",   nrow(mt[mt$X_dv12 > QA_dv12,]),"rows\n"))
            cat(paste("Fail: QA_GM  ",   nrow(mt[mt$X_Gm   < QA_GM,]),  "rows\n"))
            cat(paste("Fail: QA_Dur ",   nrow(mt[mt$X_dur  < QA_Dur,]), "rows\n"))
            cat(paste("Fail: QA_H1  ",   nrow(mt[mt$X_H1   > QA_H1,]),  "rows\n"))
            cat(paste("Fail: QA_H2  ",   nrow(mt[mt$X_H2   < QA_H2,]),  "rows\n"))      
            cat(paste("Fail: QA_Qc  ",   nrow(mt[mt$X_Qc   < QA_Qc,]),  "rows\n"))

            if (! Apply_QA) {
                cat("Note: QA filtering is currently disabled")
            } 
            }
}  
    
    
    