# =================================================================
#
#-- Histogram showing the number of 2, 3, 4... station matches
#
#-- Author: Peter Campbell-Burns, UKMON
#-- Version 1.0, 12/12/2015
#
#-- Shared under the Creative Common  Non Commercial Sharealike 
#   License V4.0 (www.creativecommons.org/licebses/by-nc-sa/4.0/)
##
# =================================================================

par(mai=c(1.0,1.5,0.5,1.0))

mu_filtered <- subset(mu, substring(X_ID1,2,8) == "UNIFIED")

tmptab <- table(mu_filtered$X_ID1)
tmpfrm <-as.data.frame(tmptab)

bgraph <- barplot(tmptab,
            xlab="Meteor counts",horiz=TRUE,
            las=1, 
            col="lightblue",
            main=paste("Number of matched observations",Streamname),
            sub=DataSet)

text( tmpfrm$Freq, bgraph, labels=paste(substring("             ",1,nchar(tmpfrm$Freq)+7),tmpfrm$Freq),pos=3, offset=-0.3,adj=c(0,0),xpd=NA)


# Cleanup
rm(mu_filtered)
rm(bgraph)
rm(tmptab)
rm(tmpfrm)