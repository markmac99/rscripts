# =================================================================
#
#-- Histogram showing the number of 2, 3, 4... station matches
#
#-- Author: Peter Campbell-Burns, UKMON
#-- Version 1.0, 12/12/2015
#
#-- Shared under the Creative Common  Non Commercial Sharealike 
#   License V4.0 (www.creativecommons.org/licebses/by-nc-sa/4.0/)
##
# =================================================================

par(mai=c(1.0,1.5,0.5,1.0))
max_traj <- 100


mf <- mu[mu$X_LD21<=max_traj,c("X_LD21","X_stream")]


if (nrow(mf) > 0) {
  
    # Select and configure the output device
    select_dev(Outfile, Otype=output_type, wd= paper_width, ht=paper_height, pp=paper_orientation)
    Plot_Rows = 3
    Plot_Cols = 4
    oldpar <- par(mfrow=c(Plot_Rows,Plot_Cols))
    par(mar=c(2.5,1,2,1), oma=c(1,1,3,1))
  
    
    streamcount <- table(mf$X_stream)
    streamcount <- as.data.frame(streamcount)
    streamlist  <- streamcount$Var1 
    streamlist  <- sort(streamlist)
    
    
    for (x in streamlist)    
    {
    
      strm <- mf[grepl(x,mf$X_stream),c("X_LD21","X_stream")]

          if (nrow(strm) > 0) {    
          bgraph <- hist(strm$X_LD21,
                  xlab="Length (km)",
                  breaks = 100,
                  xlim = range(0,max_traj),
                  main=paste(x),
                  sub=DataSet)
      }
    }
    
    # Cleanup
    par(mfrow=c(1,1))
    par(oldpar)
    rm(strm)
    rm(streamcount)
    rm(streamlist)
    rm(bgraph)

} else {
  cat(" *** No data ")
}
rm(mf)