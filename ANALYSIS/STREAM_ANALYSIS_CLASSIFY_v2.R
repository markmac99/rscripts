#=============================================================================
#
#-- Author: P Campbell-Burns, UKMON
#-- Date:   11 September 2015
#
#
#-- Description:
#
#   This script processes iteratively a UFO orbit export f UNIFIED data, each pass
#   calculating D_Criterion against a reference orbit for a stream.  If the criteria 
#   is below a defined threshold for an observation, the observation is assigned to the
#   current stream.  If a subsequent stream gets a better match, the stream is again 
#   reasigned to the best match.
#
#   Environment varables are set by script Lib_Config.r which sets pointers
#   to source data, directory holding the scripts, directory recieving reports
#   etc. This file must be first configured to match the installation.
#
#   Note, the distribution (ANALYSIS folder) must be held in My Documents
#
#-- Shared under the Creative Common  Non Commercial Sharealike 
#   License V4.0 (www.creativecommons.org/licebses/by-nc-sa/4.0/)
#
#   Vers  Date          Notes
#   ----  ----          -----
#   2.1   09/02/2016    Moved root path from config file to improve MacOS compatibility
#   2.0   20/10/2016    Defects resolved, Disable / enable QA filter option added
#   1.0   03/12/2016    First release
#
#
#=============================================================================


#-- Filesystem parameters

root = "~/ANALYSIS"					 # Filesystem root (~ is users documents folder on Windows)

# Initialise environment variables and common functions

    source(paste(root, "/ANALYSIS/CONFIG/Lib_Config.r",sep=""))
    source(paste(FuncDir,"/common_functions.r",sep=""))
    source(paste(FuncDir,"/D_Criteria.r",sep=""))
    source(paste(FuncDir,"/Orbital_Elements.r",sep=""))

# Set the R working directory (this is where R saves its environment)

    setwd(WorkingDir)
  
# Read UNIFIED CSV file created by UFO Orbit (all columns are read) and standardise data

    mt <- read_ufo()
    rows_read <- nrow(mt)
    if (rows_read == 0) {
        stop("No data in input file")
    	} else {

      cat(paste("*** Rows read from input file",as.character(rows_read),"\n"))
  
  # Select which stream / year to process
  #   SelectYr <- get_year(mt)
  
  # Get UNIFIED and Single observations
  
      mu <- filter_stream(mt, mtype="UNIFIED")
      if (nrow(mu) == 0) {
          stop("No data in UNIFIED dataframe")
      } else {
  
        # Apply Quality Criteria
            
        if (Apply_QA) {
          z <- filter_apply_qa(mu)
        } else {
          z <- mu
        }
            
        rows_to_process <- nrow(z)
        if (rows_to_process == 0) {
          stop("No data to process - check QA filter settings")
        } else {
              
                z["Stream"] <- "UNMATCHED"
                z["D_Best_match"] <- 9999
            
                pdf(paste(ReportDir,"/D_Criterion.pdf",sep=""),onefile=TRUE, paper=as.character("a4r"), width = 1745, height = 877)
                
                Plot_Rows = 2
                Plot_Cols = 3
                oldpar <- par(mfrow=c(Plot_Rows,Plot_Cols))
                par(mar=c(2.5,1,2,1), oma=c(1,1,3,1))
              
                for (idx in 1:nrow(stream_list)) {
                 
                  stream_name <- as.character(stream_list[idx,"stream_name"])
                 
                  e = stream_list[idx,"e"]
                  q = stream_list[idx,"q"]
                  i = stream_list[idx,"i"]
                  n = stream_list[idx,"n"]
                  p = stream_list[idx,"p"]
                  d_threshold = stream_list[idx,"d_threshold"]
                 
                  z<-DCalc(z, e,q,i,n,p)
                    
                  a = intersect ( which(z["D_Value"]<=d_threshold ), which(z["D_Value"]<=z["D_Best_match"]) )
                  if (length(a) > 0) {
                    z[a,"Stream"] <- stream_name
                    z[a,"D_best__match"] <- pmin(z[a,"D_Best_match"],z[a,"D_Value"])
                    rng = 1
                    plot.new()
                    a = z[z$Stream==stream_name,]
                    hist(a$D_Value, col="blue",
                         main = paste("DD Criteria match against",stream_name),
                         breaks = c(seq(0,rng,0.005)),
                         xlab = paste("DD value"),xlim=c(0,rng))
                  }
               }
            
            par(oldpar)
            par(mfrow=c(1,1))
          }  
        }
    	} 