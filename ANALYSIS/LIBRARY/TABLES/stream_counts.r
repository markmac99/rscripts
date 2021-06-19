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

outfile = paste(Set_Outfile("/TABLE_stream_counts", Yr = SelectYr, Stream = SelectStream), ".csv", sep = "")

if (singletype == "UNIFIED") {
  outtab <- table(mu$X_stream)
} else {
  outtab <- table(mu$Group)
}

write.table(outtab, outfile, sep = ",", col.names = NA)
rm(outtab)