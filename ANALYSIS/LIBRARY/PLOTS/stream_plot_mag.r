# =================================================================
#
#-- Frequency distribution of meteor magnitudes
#
#-- Author: Peter Campbell-Burns, UKMON
#-- Version 1.0, 12/12/2015
#
#-- Shared under the Creative Common  Non Commercial Sharealike 
#   License V4.0 (www.creativecommons.org/licebses/by-nc-sa/4.0/)
#
#
# =================================================================

par(mai=c(1.0,1.0,0.5,0.5))

# Restrict magnitudes to prevent range problems

mf = subset(mu,X_amag >= -7 & X_amag <= 7)

# PLOT ALL Stream by mag
	bins=seq(as.integer(min(mf$X_amag))-1,as.integer(max(mf$X_amag))+1,by=0.2)
	hist(mf$X_amag,
         breaks=bins,
         border = NA,
         col="red", 
         xlab="Magnitude",
         ylab="count",
         xlim = c(-7,7),
         main=paste("Magnitude distribution",Streamname),
         sub=DataSet)

rm(bins)
rm(mf)

