
#------------------------------------------------------
#-- Author: Peter Campbell-Burns, UKMON
#-- Version 1.0, 12/12/2015
#
#-- Distribution of distance from catalogue 
#   Radiant position plotted RA vs Dec
#
#-- Shared under the Creative Common  Non Commercial Sharealike 
#   License V4.0 (www.creativecommons.org/licebses/by-nc-sa/4.0/)
#
#
#------------------------------------------------------

bins=seq(as.integer(min(mu$X_dr))-1,as.integer(max(mu$X_dr))+1,by=0.2)
hist(mu$X_dr,
     breaks=bins,
#     border = NA,
     col="blue", 
     xlab="Magnitude",
     ylab="count",
     xlim = c(0,as.integer(max(mu$X_dr))+1),
     main=paste("Distance from Radiant",Streamname),
     sub=DataSet)

rm(bins)


