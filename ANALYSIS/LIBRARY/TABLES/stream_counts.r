# =================================================================
#
#-- Author: Peter Campbell-Burns, UKMON
#-- Version 1.0, 12/12/2015
#
#-- Shared under the Creative Common  Non Commercial Sharealike 
#   License V4.0 (www,creativecommons.org/licebses/by-nc-sa/4.0/)
#
#
# =================================================================

outfile = paste(Set_Outfile("/TABLE_stream_counts",Yr=SelectYr, Stream=SelectStream),".csv",sep="")


outtab <- table(mu$X_stream) 

write.table(outtab,outfile, sep=",",col.names=NA)
rm(outtab)