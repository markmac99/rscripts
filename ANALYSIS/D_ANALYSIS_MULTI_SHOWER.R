#=============================================================================
#
#-- Author: P Campbell-Burns, UKMON
#-- Date:   1 December 2015
#
#
#-- Description:
#
#   This script processes iteratively a UFO orbit export fie of UNIFIED data, each pass
#   calculating D_Criterion against a DIFFERENT reference orbit for a stream.  The p
#   probability density function and cumulative frequency is then plotted for each stream.
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

d_threshold = 0.6
Binsize     = 0.01
D_Type      = "DD"
J_catalog   = paste(".","/CONFIG/j8.csv",sep="")

# Initialise environment variables and common functions

    source(paste(".","/CONFIG/Lib_Config.r",sep=""))
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
        
                  pdf(paste(ReportDir,"/D_Criterion_multi.pdf",sep=""),onefile=TRUE, paper=as.character("a4r"), width = 1745, height = 877)
                  par(mfrow=c(2,2))
                  par(mar=c(5, 6, 2, 4))
                  par(new=TRUE)
                    
                  for (ix in 1:nrow(streamlist)) {

                      stream_name = streamlist$X_name[ix]
                      cat(paste("Pass ", ix, ": ", stream_name,"\n",sep=""))
                      Plot_title  = stream_name
                      
                      # Get orbital elements              
                      e  = as.numeric(streamlist$X_e[ix])
                      q  = as.numeric(streamlist$X_q[ix])
                      i  = as.numeric(streamlist$X_incl[ix])
                      n  = as.numeric(streamlist$X_node[ix])
                      p  = as.numeric(streamlist$X_peri[ix])
                      s1 = as.numeric(streamlist$X_sol1[ix])
                      s2 = as.numeric(streamlist$X_sol2[ix])
                     
                      # Run D-analysis and filter to <= threshold
                      zlist <-mu[mu$X_sol >= s1 & mu$X_sol <= s2 ,]

                      if (nrow(zlist) > 10 & ! is.na(e)) {
                        zlist <-DCalc(zlist, e,q,i,n,p,D_Type = D_Type)
                        zlist <-zlist[zlist$D_Value <= d_threshold,]
                        }
                      
                      if (nrow(zlist) > 10 & ! is.na(e)) {
                    
                          # Generate stats
                          ah <- hist(zlist$D_Value, plot = FALSE, breaks = c(seq(0,d_threshold,Binsize)))
        
                          # Get cumulative counts
                          ahcum <- cumsum(ah$counts)
                          
                          # Open PDF device
                          options(scipen=999)
                          # Generate plot
                          par(ps = 12, cex = 1, cex.main = 1)
                          plot(ah$mid,ah$counts,type="l",col="red",xlim=c(0,d_threshold),main = Plot_title, xlab="", ylab = "", axes = FALSE)
                          axis(side = 1, at = seq(0,d_threshold,0.1),  tcl = -0.2)
                          axis(side = 2)
                          mtext("Differential counts", side=2, line=2)
                          par(new=TRUE)
                          plot(ah$mid,ahcum,type="l", col="blue",axes=FALSE,ann=FALSE,xlim=c(0,d_threshold))
                          axis(side = 4)
                          mtext("Cumulative counts", side=4, line=2)
                          mtext(paste(D_Type," (Bin size ",Binsize,")",sep=""), side=1, line=3)
                          axis(4)
                          
                  }
                  }
                  dev.off() 
          }  
        }
    	} 

par(mfrow=c(1,1))
    