# =================================================================
#
#-- Histogram showing distribution of velocities
#
#-- Author: Peter Campbell-Burns, UKMON
#-- Version 1.0, 12/12/2015
#
#-- Shared under the Creative Common  Non Commercial Sharealike 
#   License V4.0 (www.creativecommons.org/licebses/by-nc-sa/4.0/)
#
#
# =================================================================

# Set-up JPEG

par(mai=c(1.0,1.0,0.5,0.5))

# Restrict velocity to prevent range problems

mf = subset(mu,mu$X_vo>=0 & mu$X_vo<=120)


if (nrow(mf) > 0 ) {
  
  # Select and configure the output device
  select_dev(Outfile, Otype=output_type, wd= paper_width, ht=paper_height, pp=paper_orientation)
  
    
    # PLOT ALL Stream by velocity
        bins=seq(0,120,by=0.5)
        hist(mf$X_vo,
             breaks=bins, 
             col="blue", 
             xlab="Velocity (km/s)", 
             ylab="count", 
             main=paste("Velocity distribution", Streamname),
             sub=DataSet)
    
    # Tidy up
    rm(bins)

} else {
  cat(" *** No data - plot skipped ")
}
rm(mf)