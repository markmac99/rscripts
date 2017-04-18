#=============================================================================
#
#-- Author: P Campbell-Burns, UKMON
#-- Date:   1 December 2015
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
#   2.0   20/10/2016    Defects resolved, Disable / enable QA filter option added
#   1.0   03/12/2016    First release
#
#
#=============================================================================

#-- Filesystem parameters

root = "~/ANALYSIS"					 # Filesystem root (~ is users documents folder on Windows)

d_threshold = 0.8
Plot_title  = "Perseids (EDMOND dataset: 2001 to 2015)"
Binsize     = 0.002
D_Type      = "DD"
J_catalog   = paste(root,"/CONFIG/j8.csv",sep="")

# Initialise environment variables and common functions

    source(paste(root,"/CONFIG/Lib_Config.r",sep=""))
    source(paste(FuncDir,"/common_functions.r",sep=""))
    source(paste(FuncDir,"/D_Criteria.r",sep=""))
    
# Import stream data
  streamlist = read.csv(J_catalog, header=TRUE)
  streamlist <- streamlist[!is.na(streamlist$X_name) & !(streamlist$X_name =="SPO"),]

# Set the R working directory (this is where R saves its environment)

    setwd(WorkingDir)
  
# Read UNIFIED CSV file created by UFO Orbit (all columns are read) and standardise data

    mt <- read_ufo()
    rows_read <- nrow(mt)
    if (rows_read == 0) {
        stop("No data in input file")
    	} else {

      cat(paste("*** Rows read from input file",as.character(rows_read),"\n"))
  
  # Get UNIFIED observations
  
      mu <- filter_stream(mt, mtype="UNIFIED")
      if (nrow(mu) == 0) {
          stop("No data in UNIFIED dataframe")
      } else {
  
        # Apply Quality Criteria
            
        if (Apply_QA) {
          mu <- filter_apply_qa(mu)
        } 
            
        rows_to_process <- nrow(mu)
        if (rows_to_process == 0) {
          stop("No data to process - check QA filter settings")
        } else {
                  mu$D_Value  <- 9999
                  mu$D_Stream <- "SPO"
                  for (ix in 1:nrow(streamlist)) {
                    
                      stream_name = as.factor(streamlist$X_name[ix])
                      
                      # Get orbital elements              
                      e = as.numeric(streamlist$X_e[ix])
                      q = as.numeric(streamlist$X_q[ix])
                      i = as.numeric(streamlist$X_incl[ix])
                      n = as.numeric(streamlist$X_node[ix])
                      p = as.numeric(streamlist$X_peri[ix])
                     
                      # Run D-analysis and filter to <= threshold
                      zlist  <-DCalc(mu, e,q,i,n,p,D_Type = D_Type)
                      idx <- (zlist$D_Value <= mu$D_Value) & (zlist$D_Value <= d_threshold)
                      mu$D_Stream[idx] <- as.character(stream_name)
                      mu$D_Value[idx]  <- zlist$D_Value[idx]
                      
                  }
                  
                  mu_tab = table(mu$D_Stream, mu$X_stream)
                  result_tab <- NA
                  for (i in 1:nrow(mu_tab)) {
                    for (j in 1:ncol(mu_tab)) {
                      if (mu_tab[i,j]> 0) {
                        result_tab <- rbind(result_tab, data.frame(rownames(mu_tab)[i],colnames(mu_tab)[j],mu_tab[i,j]))
                      }
                    }
                  }
                  
                  colnames(result_tab) <- c("D_ANALYSIS","UFO", "Count")
                  result_tab <- result_tab[with(result_tab, order(Count)),] 
                  
          }  
        }
    	} 