# =================================================================
#
#-- Plot meteor stream duration
#
#-- Author: Peter Campbell-Burns, UKMON
#-- Version 1.0, 12/12/2015
#
#-- Shared under the Creative Common  Non Commercial Sharealike 
#   License V4.0 (www.creativecommons.org/licebses/by-nc-sa/4.0/)
#
#
# =================================================================


par(mai=c(1.0,1.5,0.5,1.0))
max_traj <- 100

mf <- mu[mu$X_LD21<=max_traj,"X_LD21"]


bgraph <- hist(mf , 
               xlab="Length (in km)",
               ylab="Count",
               main=paste("Length of observed trajectory\n"),
               breaks = 100,
               xlim = range(0,max_traj),
               sub=DataSet)

rm(bgraph)
rm(mf)

