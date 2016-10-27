
#------------------------------------------------------
#-- Author: Peter Campbell-Burns, UKMON
#-- Version 1.0, 12/12/2015
#
#-- Radiant position plotted RA vs Dec
#
#-- Shared under the Creative Common  Non Commercial Sharealike 
#   License V4.0 (www.creativecommons.org/licebses/by-nc-sa/4.0/)
#
#
#------------------------------------------------------

plot(mu$X_ra_o, mu$X_dc_o,
     main=paste("Radiant plot",Streamname), 
     sub=DataSet,
     xlab="Right Ascension (deg)", 
     ylab="Declination (deg)",
     col="blue"
)

