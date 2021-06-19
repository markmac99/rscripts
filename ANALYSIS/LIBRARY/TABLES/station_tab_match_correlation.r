# =================================================================
#
#-- Author: Peter Campbell-Burns, UKMON
#-- Version 1.0, 12/12/2015
#
#-- Shared under the Creative Common  Non Commercial Sharealike 
#   License V4.0 (www,creativecommons.org/licebses/by-nc-sa/4.0/)
#

#==================================================================
outfile = paste(Set_Outfile("/TABLE_station_match_correlation", Yr = SelectYr, Stream = SelectStream), ".csv", sep = "")

# can only really do this with the old UFO data
if (singletype == "UNIFIED") {
  tmp <- subset(mt, substring(mt$X_ID1, 2, 8) != "UNIFIED")
  tmp$X_ID2 = substr(tmp$X_ID2, 2, 30)

  outtab <- table(tmp$X_ID1, tmp$X_ID2)

  write.table(outtab, outfile, sep = ",", col.names = NA)

  rm(tmp)
  rm(outtab)
}