
#------------------------------------------------------
#-- Author: Peter Campbell-Burns, UKMON
#-- Version 1.0, 12/12/2015
#
#-- Scatterplot of Absolute magnitude vs H1 / H2
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

# Create base plot for H1

plot(mf$X_H1~mf$X_amag,
     main=paste("Absolute magnitude vs H1 / H2",Streamname), 
     sub=DataSet,
     xlab="Absolute Magnitude", 
     ylab="Altitude (km)", 
     pch=20, cex=0.5,
     xlim=c(-7,3),
     ylim=c(20,140)) 

# Line fit (H1) and extract gradient and intercept

al <- lm(mf$X_H1~mf$X_amag,data=mf)
aIntercept = substring(as.character(coef(al)[1]),1,6)
aGradient  = substring(as.character(coef(al)[2]),1,6)

# Plot H1 line fit and annotate

abline(al)
text(cex=0.9,x=-2,y=50,paste("H1: y =",aGradient,".x +",aIntercept))


# Create base plot for H2 on same graph

par(new=TRUE)

plot(mf$X_H2~mf$X_amag, 
     col="red",  
     cex=0.5, 
     pch=20, 
     xlim=c(-7,3), 
     ylim=c(20,140),
     xlab="",
     ylab="")  

# Line fit (H1) and extract gradient and intercept

bl <- lm(mf$X_H2~mf$X_amag,data=mf)
bIntercept = substring(as.character(coef(bl)[1]),1,6)
bGradient  = substring(as.character(coef(bl)[2]),1,6)

# Plot H2 line fit and annotate

abline(bl)
text(cex=0.9,x=-2,y=40,paste("H2: y =",bGradient,".x +",bIntercept))

# Add legend to plot

legend('bottomleft', c("H1","H2"), lty=1, col=c("blue","red"), bty='n', horiz=TRUE)

# Cleanup
rm(al)
rm(bl)
rm(mf)

