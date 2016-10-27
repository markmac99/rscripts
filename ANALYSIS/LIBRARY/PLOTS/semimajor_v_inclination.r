#------------------------------------------------------
#
#-- Scatterplot of semi-major axis vs orbit inclination 
#
#-- Author: Peter Campbell-Burns, UKMON
#-- Version 1.0, 12/12/2015
#
#-- Shared under the Creative Common  Non Commercial Sharealike 
#   License V4.0 (www.creativecommons.org/licebses/by-nc-sa/4.0/)
#
#------------------------------------------------------

par(mai=c(1.4,1.0,1.7,0.5))

mf <- mu[mu$X_a >=0,]
plot(mf$X_a, 
     mf$X_incl, 
     ylim=c(0,180), 
     xlim=c(0,150),
     xlab="Semi-major Axis (AU)", 
     ylab="Inclination", 
     pch=20, 
     cex=0.6,
     main=paste("Semi-major axis vs Inclination \n",Streamname),
     sub=DataSet) 


# Tidy Up

rm(mf)

