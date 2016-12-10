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


mu_filtered <- subset(mu, substring(X_ID1,2,8) == "UNIFIED")

if (nrow(mu_filtered) > 0) {
  
    # Select and configure the output device
    select_dev(Outfile, Otype=output_type, wd= paper_width, ht=paper_height, pp=paper_orientation)
    par(mar=c(2,4,3,2))
    par(oma=c(2,4,3,2))
    tmptab <- table(mu_filtered$X_ID1)
    tmpfrm <-as.data.frame(tmptab)
    
    bgraph <- barplot(tmptab,
                xlab="Meteor counts",horiz=TRUE,
                las=1, 
                col="lightblue",
                main=paste("Number of matched observations",Streamname),
                sub=DataSet)
    
    text( tmpfrm$Freq, bgraph, labels=paste(substring("             ",1,nchar(tmpfrm$Freq)+7),tmpfrm$Freq),pos=3, offset=-0.3,adj=c(0,0),xpd=NA)

    rm(bgraph)
    rm(tmptab)
    rm(tmpfrm)
    
} else {
    cat(" *** No data")
}    

# Cleanup
rm(mu_filtered)