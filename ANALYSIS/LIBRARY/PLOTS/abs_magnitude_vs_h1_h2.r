#------------------------------------------------------
#-- Author: Peter Campbell-Burns, UKMON
#-- Version 1.0, 12/12/2015
#
#-- Scatterplot of Absolute magnitude vs H1 / H2
#
#-- Shared under the Creative Common  Non Commercial Sharealike 
#   License V4.0 (www.creativecommons.org/licebses/by-nc-sa/4.0/)
#
#
#------------------------------------------------------

par(mai=c(1.0,1.0,0.5,0.5))

plot(mu$X_amag, 
     mu$X_H1, 
     main=paste("Absolute magnitude vs H1 / H2",Streamname), 
     sub=DataSet,
     xlab="Absolute Magnitude", 
     ylab="Altitude (km)",
     pch=20, 
     cex=0.7, 
     xlim=c(-7,3),
     ylim=c(20,140)) 

par(new=TRUE)

plot(mu$X_amag, 
     mu$X_H2, 
     col="red",  
     cex=0.7, 
     pch=20, 
     xlim=c(-7,3), 
     ylim=c(20,140),
     xlab="",
     ylab="") 

legend('bottomleft', c("H1","H2"), lty=1, col=c("blue","red"), bty='n', horiz=TRUE)
