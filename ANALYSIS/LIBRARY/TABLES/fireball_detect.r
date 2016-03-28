# =================================================================
#
#-- Author: Peter Campbell-Burns, UKMON
#-- Version 1.0, 12/12/2015
#
#-- Shared under the Creative Common  Non Commercial Sharealike 
#   License V4.0 (www,creativecommons.org/licebses/by-nc-sa/4.0/)
#
#-- Scan for fireballs from single and unified observations
#
# =================================================================

outfile = paste(ReportDir,"/TABLE_Fireballs_",SelectStream,"_",SelectYr,".csv",sep="")

# Look for fireball magnitudes
fireball <- mu[mu$X_mag <= -4, c("X_localtime","X_mag","X_ID1","X_stream")]


fireball <- fireball[order(fireball$X_mag),]
fireball$X_matches <- substring(fireball$X_ID1,regexpr("_",fireball$X_ID1)+1,regexpr(")",fireball$X_ID1)-1)

fireball <- fireball[order(fireball$X_localtime),]

write.table(fireball,outfile, sep=",",col.names=NA)

rm(fireball)