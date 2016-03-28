
#------------------------------------------------------
#
#-- Author: Peter Campbell-Burns, UKMON
#-- Version 1.0, 12/12/2015
#
#-- Scatterplot of Absolute magnitude vs (H1 - H2)
#   With least squares line fit
#
#-- Shared under the Creative Common  Non Commercial Sharealike 
#   License V4.0 (www.creativecommons.org/licebses/by-nc-sa/4.0/)
#
#
#------------------------------------------------------

par(mai=c(1.0,1.0,0.5,0.5))

# Restrict heights and amag to sensible ranges

mf <- mu[mu$X_H1 < 140 & mu$X_H2 < 140 & mu$X_amag >= -7 & mu$X_amag<=3,]
mf$X_Hd <- mf$X_H1 - mf$X_H2
# Create base plot for H1

plot(mf$X_Hd~mf$X_amag,
     main=paste("Absolute magnitude vs height difference (H1 - H2)",Streamname), 
     sub=DataSet,
     xlab="Absolute Magnitude", 
     ylab="Height difference (km)", 
     pch=20, cex=0.5,
     xlim=c(-7,3),
     ylim=c(0,80),
     col="blue") 

# Line fit (H1) and extract gradient and intercept

al <- lm(mf$X_Hd~mf$X_amag,data=mf)
aIntercept = substring(as.character(coef(al)[1]),1,6)
aGradient  = substring(as.character(coef(al)[2]),1,6)

# Plot H1 line fit and annotate

abline(al)
text(cex=0.9,x=-2,y=75,paste("Hd: y =",aGradient,".x +",aIntercept))

rm(al)
rm(mf)