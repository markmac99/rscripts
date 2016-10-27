# =================================================================
#
#-- Author: Peter Campbell-Burns, UKMON
#-- Version 1.0, 12/12/2015
#
# =================================================================

par(mai=c(1.0,1.5,0.5,1.0))

mu_filtered <- subset(mu, substring(X_ID1,2,8) == "UNIFIED")

tmptab = table(mu_filtered$X_ID1)

bgraph = barplot(tmptab,
        xlab="Meteor counts",horiz=TRUE,
        las=1, 
        col="lightblue",
        main=paste("Number of matched observations",Streamname),
        sub=DataSet)

text( tmptab, bgraph, labels=paste(substring("             ",1,nchar(tmpmat)+7),tmpmat),pos=3, offset=-0.3,adj=c(0,0),xpd=NA)



# Cleanuprm

rm(mu_filtered)
