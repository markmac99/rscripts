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

Stream      <- data.frame(stream_name="Perseids",  p=149.513875,    n=139.194266,   i=113.038548, e=0.912969,  q=0.949) 
d_threshold = 0.8
Plot_title  = "Perseids (EDMOND dataset: 2001 to 2015)"
Binsize     = 0.002
D_Type      = "DD"

# Initialise environment variables and common functions

    source("~/ANALYSIS/CONFIG/Lib_Config.r")
    source(paste(FuncDir,"/common_functions.r",sep=""))
    source(paste(FuncDir,"/D_Criteria.r",sep=""))
    

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
          zlist <- filter_apply_qa(mu)
        } else {
          zlist <- mu
        }
            
        rows_to_process <- nrow(zlist)
        if (rows_to_process == 0) {
          stop("No data to process - check QA filter settings")
        } else {

                  # Get orbital elements              
                  e = as.numeric(Stream["e"])
                  q = as.numeric(Stream["q"])
                  i = as.numeric(Stream["i"])
                  n = as.numeric(Stream["n"])
                  p = as.numeric(Stream["p"])
                 
                  # Run D-analysis and filter to <= threshold
                  zlist  <-DCalc(zlist, e,q,i,n,p,D_Type = D_Type)
                  zlist <- zlist[zlist$D_Value <= d_threshold,]
                  
                  # Generate stats
                  ah <- hist(zlist$D_Value, plot = FALSE, breaks = c(seq(0,d_threshold,Binsize)))

                  # Get cumulative counts
                  ahcum <- cumsum(ah$counts)
                  
                  # Open PDF device
                  options(scipen=999)
                  pdf(paste(ReportDir,"/D_Criterion.pdf",sep=""),onefile=TRUE, paper=as.character("a4r"), width = 1745, height = 877)
                  # Generate plot
                  par(mar=c(5, 6, 2, 4))
                  par(mfrow=c(1,1))
                  plot(ah$mid,ah$counts,type="l",col="red",xlim=c(0,d_threshold),main = Plot_title, xlab="", ylab = "", axes = FALSE)
                  axis(side = 1, at = seq(0,d_threshold,0.1),  tcl = -0.2)
                  axis(side = 2)
                  mtext("Differential counts", side=2, line=2)
                  par(new=TRUE)
                  plot(ah$mid,ahcum,type="l", col="blue",axes=FALSE,ann=FALSE,xlim=c(0,d_threshold))
                  axis(side = 4)
                  mtext("Cumulative counts", side=4, line=2)
                  mtext(D_Type, side=1, line=3)
                  axis(4)
                  dev.off()                
          }  
        }
    	} 