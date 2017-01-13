#=============================================================================
#
#-- Author: P Campbell-Burns, UKMON
#
#
#-- Description:
#
#   This script runs a set of R scripts which generate tables and reports
#   from a file containing UNIFIED observations created using UFO Orbit.  
#
#   This script prompts the user for the output type (PDF, JPEG or CONSOLE), 
#   a stream name and year.  It then filters and standardises UFO orbit data
#   before calling the plot / table routines.
#
#   Each script can use the following data prepared by this master script:
#
#   mu:           Dataframe containing imported UNIFIED UFO Orbit data
#   ms:           Dataframe containing imported paired station UFO Orbit data
#   Dataset:      A desciptive title printed on the plot footer
#   SelectStream: The 3 digit mnemonic for the stream
#   Streamname:   The common name of the stream
#   SelectStart:  The start time for timeline plots (if available)
#   SelectEnd:    The start time for timeline plots (if available)
#   Solpeak:      Solar longitude of a shower peak
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
#-- Version history
#
#   Vers  Date          Notes
#   ----  ----          -----
#   2.0   20/10/2016    Defects resolved, Disable / enable QA filter option added
#   1.1   20/09/2016    Added QA criteria function call 
#   1.0   03/12/2016    First release
#
#=============================================================================

cat("Reporting started",format(Sys.time(), "%a %b %d %Y %H:%M:%S"))

# Initialise environment variables and common functions

  source("~/ANALYSIS/CONFIG/Lib_Config.r")
  source(paste(FuncDir,"/common_functions.r",sep=""))

  runtime = format(Sys.time(),"%Y%m%d_%H%M")

# Close any open graphical output devices (other than NULL)
  repeat{
    if(dev.cur() == 1) {
      break
    }
    dev.off()
  }

  # Select Output Type
  if (is.na(OutType)) {
    Olist = c("PDF","JPG")
    i <- menu(Olist, graphics=TRUE, title="Choose output type")
    OutType = Olist[i]
  }
  
# Set the R working directory (this is where R saves its environment)

    setwd(WorkingDir)
  
# Read UNIFIED CSV file created by UFO Orbit (all columns are read) and standardise data

    mt <- read_ufo()
    
    # Following is a quick fix to a UFO data Issue
    if (is.factor(mt$X_amag)) {
      cat("Note: Problem detected in input data - amag converted from factor to numeric \n      Ignore next cooercion warnings")
      mt$X_amag <- as.numeric(as.character(mt$X_amag))
      mt <- mt[!is.na(mt$X_amag),]
    }
    
    if (is.factor(mt$X_QA)) {
      cat("Note: Problem detected in input data - QA converted from factor to numeric")
      mt$X_QA <- as.numeric(as.character(mt$X_QA))
      mt <- mt[!is.na(mt$X_QA),]
    }
    
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
        Solpeak      = as.numeric(stream[3,])
        SelectStart  = stream[4,]
        SelectEnd    = stream[5,]
    
    # Get UNIFIED and Single observations
    
        mu <- filter_stream(mt, mstream=SelectStream, myr=SelectYr, mtype="UNIFIED")
        ms <- filter_stream(mt, mstream=SelectStream, myr=SelectYr, mtype="OTHER")
    
        if (nrow(mu) == 0) {
            stop(paste("No UNIFIED observations for stream",SelectStream,"were found in the input data"))
            } else {
        
        # Apply Quality Criteria
            
            if (Apply_QA) {
                mu <- filter_apply_qa(mu)
            }
            
            rows_to_process <- nrow(mu)
            if (rows_to_process == 0) {
              stop ("No data to process - check / adjust QA filter settings")
            } else {
            
            # Set dataset title
            
                DataSet=paste("Dataset:",SelectStream,"period",substring(min(mu$X_local),1,10),"to",substring(max(mu$X_local),1,10))
            
            # Generate generic plots
            cat("\n",
                "Output type:       ",OutType,"\n",
                "QA filter enabled: ",Apply_QA,"\n\n",sep="")            
            Runscript("stream_plot_by_correllation.r",Otype=OutType,orient=Landscape)
            Runscript("stream_plot_mag.r",Otype=OutType,orient=Landscape)
            Runscript("stream_plot_vel.r",Otype=OutType,orient=Landscape)
            Runscript("stream_ablation.r",Otype=OutType,orient=Landscape)
            Runscript("semiMajor_v_inclination.r",Otype=OutType,orient=Portrait)
            Runscript("semimajor_v_ascending.r",Otype=OutType,orient=Portrait)
            Runscript("abs_magnitude_vs_h1_h2_reg.r",Otype=OutType,orient=Landscape)
            Runscript("abs_magnitude_vs_h_diff_reg.r",Otype=OutType,orient=Landscape)
            Runscript("abs_magnitude_vs_h1_h2.r",Otype=OutType,orient=Landscape)
            Runscript("heliocentric_Velocity.r",Otype=OutType,orient=Landscape)
            Runscript("semimajoraxisfreq.r",Otype=OutType,orient=Portrait)
            Runscript("fireball_by_month.r",Otype=OutType,orient=Landscape)
            Runscript("a_binned.r",Otype=OutType,orient=Landscape)
            Runscript("a_binned_multi.r",Otype=OutType,orient=Portrait)
            Runscript("meteor_duration.r",Otype=OutType,orient=Landscape)
            Runscript("observed_trajectory_LD21.r",Otype=OutType,orient=Landscape)
            
            #-- Generate generic tables
            
            source(paste(TabsDir,"fireball_detect.R",sep="/"))
            source(paste(TabsDir,"stream_counts_by_year.r",sep="/")) 
            
            # Run scripts relevant only to streams
            
            if (SelectStream != "ALL" & SelectStream != "SPO")
                {
                    Runscript("stream_plot_radiant_movement.r",Otype=OutType, orient=Landscape)
                    Runscript("stream_plot_timeline_solar.r",Otype=OutType,orient=Landscape)
                    Runscript("stream_plot_radiant.r",Otype=OutType,orient=Landscape)
                    Runscript("stream_plot_radiant_delta.r",Otype=OutType,orient=Landscape)
                } else {
                	cat(paste("Note: Stream-only plots have been excluded","\n"))
                }
            
            # Run scripts relevant only to "ALL streams" plots
            
            if (SelectStream == "ALL")
                {
                    Runscript("streamcounts.r",Otype=OutType,orient=Landscape)
                    Runscript("fireball_by_stream.r",Otype=OutType,orient=Landscape)
                    Runscript("counts_by_sol.r",Otype=OutType,orient=Landscape)   
                    Runscript("observed_trajectory_LD21_by_stream.r",Otype="PDF",orient=Landscape)                       
        
                } else {
                	cat(paste("Note: Plots for ALL have been excluded","\n"))
                }
            
            # The following scripts will run ONLY if there is station data in MS (not supplied by Edmond)
            # and the selected report is a Stream Report
            
            if (nrow(ms) != 0 & SelectStream != "ALL"  & SelectStream != "SPO") {
                  Runscript("stream_plot_timeline_single.r",Otype=OutType,orient=Landscape)
            }
            
            # The following scripts will run ONLY if there is station data in MS (not supplied by Edmond)
            
            if (nrow(ms) != 0) {
                	Runscript("Streamcounts_plot_by_station.r",Otype=OutType,orient=Landscape)
                	Runscript("delta_vo_overall.r",Otype=OutType,orient=Landscape)
                	Runscript("delta_vo_by_station.r",Otype="PDF",orient=Landscape)
                	Runscript("qa_by_station.r",Otype="PDF",orient=Landscape)
                	Runscript("qa_overall.r",Otype=OutType,orient=Landscape)
                	Runscript("cdeg_overall.r",Otype=OutType,orient=Landscape)
                	Runscript("cdeg_by_station.r",Otype="PDF",orient=Landscape)
                	#-- Table outputs
                	source(paste(TabsDir,"station_tab_match_correlation.r",sep="/"))
                	source(paste(TabsDir,"stream_counts_by_station.r",sep="/")) 
                	source(paste(TabsDir,"stream_counts.r",sep="/"))
                	source(paste(TabsDir,"station_tab_match_top_correlation.r",sep="/"))
                } else {    
                	cat(paste("Note: No Station data in source data (Unified only)","\n"))
                }
            
             cat("Run complete",format(Sys.time(), "%a %b %d %Y %H:%M:%S"))
          }
    
      }
  
}  
    
    
    