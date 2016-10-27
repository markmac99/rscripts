# =================================================================
#
#-- Barplot showing UNIFIED meteor counts for the top ten 
#   (by count) streams
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

# Exclude SPORADICS

tmptab <- table(mu$X_stream, exclude="SPO")

# Extract top ten counts

tmptab <- sort(tmptab, decreasing=TRUE)
tmpmat <-as.matrix(tmptab)
tmpmat <- tmpmat[1:min(10,nrow(tmpmat)),]



# Coerce to Dataframe to plot

tmpmat <-as.matrix(tmpmat)

bgraph <- barplot(t(tmpmat),
            xlab="Meteor counts",horiz=TRUE,
            las=1, 
            col="lightblue",
            main=paste("Stream counts (top ten)"),
            sub=DataSet,
            xlim=c(0,max(tmpmat)))

text( tmpmat, bgraph, labels=paste(substring("             ",1,nchar(tmpmat)+7),tmpmat),pos=3, offset=-0.3,adj=c(0,0),xpd=NA)


# Cleanup
rm(bgraph)
rm(tmptab)
rm(tmpmat)