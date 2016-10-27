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

bgraph <- hist(mu$X_dur , 
               xlab="Duration (seconds)",
               ylab="Counts",
               main=paste("Meteor Duration\n"),
               breaks = 50,
               sub=DataSet)


rm(bgraph)
