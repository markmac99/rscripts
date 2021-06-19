# =================================================================
#
#-- Barplot showing the number of observations for a specified 
#   stream, by station
#
#-- Author: Peter Campbell-Burns, UKMON
#-- Version 1.0, 12/12/2015
#
#-- Shared under the Creative Common  Non Commercial Sharealike 
#   License V4.0 (www.creativecommons.org/licebses/by-nc-sa/4.0/)
#
#
# =================================================================

# Set-up JPEG
par(mai=c(2.0,1.0,0.5,0.5))

outfile = paste(ReportDir,"/TABLE_Stream_Counts_by_Station_",SelectStream,"_",SelectYr,".csv",sep="")

MainTitle = paste("Counts of single observations by station",Streamname)


# Restrict velocity to prevent range problems

if (singletype == "UNIFIED"){
    outtab <- t(as.matrix(sort(table(ms$X_ID1),decreasing=TRUE)))
}else{
    outtab <- t(as.matrix(sort(table(ms$Loc_Cam),decreasing=TRUE)))
}

# Select and configure the output device
select_dev(Outfile, Otype=output_type, wd= paper_width, ht=paper_height, pp=paper_orientation)

h = barplot(outtab,
         main=MainTitle,
         ylab = "Counts",
         border=FALSE,
         plot = TRUE,
         col="blue",
         cex.names = 0.6, 
         las=2)

title(sub=DataSet,line=6)

rm(outtab)
rm(h)







    
