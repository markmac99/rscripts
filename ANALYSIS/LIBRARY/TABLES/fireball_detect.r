# =================================================================
#
#-- Author: Peter Campbell-Burns, UKMON
#-- Version 1.1, 12/12/2015
#
#-- Shared under the Creative Common  Non Commercial Sharealike 
#   License V4.0 (www,creativecommons.org/licebses/by-nc-sa/4.0/)
#
#-- Scan for fireballs from single and unified observations
#
#
#-- Version history
#
#   Vers  Date          Notes
#   ----  ----          -----
#   1.1   20/09/2016    Added number of matched observations 
#   1.0   03/12/2016    First release
# =================================================================

outfile = paste(Set_Outfile("/TABLE_Fireballs",Yr=SelectYr, Stream=SelectStream),".csv",sep="")

# Look for fireball magnitudes
fireball <- mu[mu$X_mag <= -4, c("X_localtime","X_mag","X_ID1","X_stream")]

fireball <- fireball[order(fireball$X_mag),]
fireball$X_matches <- ifelse(substr(fireball$X_ID1,10,10)=="0",substr(fireball$X_ID1,11,11),substr(fireball$X_ID1,10,11))

fireball <- fireball[,c("X_localtime","X_mag","X_stream","X_matches")]
colnames(fireball) <- c("localtime","magnitude","stream","station_matches")

write.table(fireball,outfile, sep=",",row.names=FALSE)

rm(fireball)