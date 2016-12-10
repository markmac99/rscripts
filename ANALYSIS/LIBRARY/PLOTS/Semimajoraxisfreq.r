#------------------------------------------------------
#
#-- Plot showing frequency distribution of Semimajor axis
#
#-- Author: Peter Campbell-Burns, UKMON
#-- Version 1.0, 12/12/2015
#
#-- Shared under the Creative Common  Non Commercial Sharealike 
#   License V4.0 (www.creativecommons.org/licebses/by-nc-sa/4.0/)
#
#------------------------------------------------------


prange = 20
mf <- subset(mu,X_a <= prange & X_a >= 0)

if (nrow(mf) > 0) {
  
    # Select and configure the output device
    select_dev(Outfile, Otype=output_type, wd=paper_width, ht=paper_height, pp=paper_orientation)

    par(mar=c(5,4,2,2))
    par(oma=c(2,3,2,2))
        
      if (max(mf$X_a) < prange) prange = max(mf$X_a) 
    
    bins=seq(0,prange+1,by=0.5)
    hist(mf$X_a,
         breaks=bins, 
         col="blue", 
         xlab="Semimajor Axis (AU)", 
         ylab="count", 
         main=paste("Semimajor Axis Frequency Distribution","\n",Streamname),
         sub = DataSet)
    
    # Tidy up
    rm(bins)

} else {
  cat(" *** No data in range, plot skipped")
}
rm(mf)