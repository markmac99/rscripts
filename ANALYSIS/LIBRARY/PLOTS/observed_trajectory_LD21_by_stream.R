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
Plot_Rows = 3
Plot_Cols = 4
oldpar <- par(mfrow=c(Plot_Rows,Plot_Cols))
par(mar=c(2.5,1,2,1), oma=c(1,1,3,1))


mf <- mu[mu$X_LD21<=max_traj,c("X_LD21","X_stream")]

streamcount <- table(mf$X_stream)
streamcount <- as.data.frame(streamcount)
streamlist  <- streamcount$Var1 
streamlist  <- sort(streamlist)


for (x in streamlist)    
{

  strm <- mf[grepl(x,mf$X_stream),"X_LD21"]

    bgraph <- hist(strm,
            xlab="Length (km)",
            breaks = 100,
            xlim = range(0,max_traj),
            main=paste(x),
            sub=DataSet)
}

# Cleanup

par(oldpar)
rm(strm)
rm(streamcount)
rm(streamlist)
rm(bgraph)
rm(mf)
