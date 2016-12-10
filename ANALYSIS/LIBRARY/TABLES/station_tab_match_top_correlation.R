# =================================================================
#
#-- Author: Peter Campbell-Burns, UKMON
#-- Version 1.0, 12/12/2015
#
#-- Shared under the Creative Common  Non Commercial Sharealike 
#   License V4.0 (www,creativecommons.org/licebses/by-nc-sa/4.0/)
#
#==================================================================
outfile = paste(Set_Outfile("/TABLE_station_match_top_correlations",Yr=SelectYr, Stream=SelectStream),".csv",sep="")

tmp <- subset(mt,substring(mt$X_ID1,2,8) != "UNIFIED")
tmp$X_ID2 = substr(tmp$X_ID2,2,30)
outtab <- table(tmp$X_ID1,tmp$X_ID2) 
unified <- data.frame()

for (irow in 1:nrow(outtab)) {
  
  for (icol in 1:min(irow,ncol(outtab))) {
    if (outtab[irow,icol] != 0) {
      unified <- rbind( unified, data.frame(row.names(outtab)[irow], colnames(outtab)[icol], outtab[irow,icol] ))
    }
    
  }
}
colnames(unified) <- c("Station_1", "Station_2", "Paired_Observations")
unified <- unified[order(unified$Paired_Observations, decreasing = TRUE),]
unified <- unified[1:20,]
write.table(unified,outfile, sep=",",col.names=NA)

rm(unified)
rm(tmp)
rm(outtab)