#=================================================================
#
#-- Author: Peter Campbell-Burns, UKMON
#-- Version 1.0, 12/12/2015
#
#-- Shared under the Creative Common  Non Commercial Sharealike 
#   License V4.0 (www,creativecommons.org/licebses/by-nc-sa/4.0/)
#
#=================================================================

# Set-up JPEG
outfile = paste(ReportDir,"/TABLE_Stream_Counts_by_Year_",SelectStream,"_",SelectYr,".csv",sep="")

MainTitle = paste("Stream counts by station",Streamname)
SubTitle  = DataSet

# Restrict velocity to prevent range problems

outtab <- table(substring(ms$X_localtime,1,4), ms$X_stream)

write.table(outtab,outfile, sep=",",col.names=NA)
rm(outtab)







    
