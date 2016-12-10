# =================================================================
#
#-- Scan for fireballs from single and unified observations
#
#-- Author: Peter Campbell-Burns, UKMON
#-- Version 1.0, 12/12/2015
#
#-- Shared under the Creative Common  Non Commercial Sharealike 
#   License V4.0 (www.creativecommons.org/licebses/by-nc-sa/4.0/)
#
#
# =================================================================

outfile = paste(ReportDir,"/TABLE_Fireballs_",SelectStream,"_",SelectYr,".csv",sep="")

# Look for fireball magnitudes

fireball <- mu[mu$X_mag <= -4, c("X_localtime","X_mag","X_ID1","X_stream")]

# Select and configure the output device
select_dev(Outfile, Otype=output_type, wd= paper_width, ht=paper_height, pp=paper_orientation)

if (nrow(fireball) > 0 ) {
    
    counts <- table(fireball$X_stream)
    
    barplot (counts,  xlab="Month",
                      ylab="Counts",
                      las=2, cex.names=0.7,
                      col="blue",
                      main=paste("Fireball count by stream"),
                      sub=DataSet)
    rm(counts)
    
} else {
  
  cat(" *** No fireballs identified in data, report skipped")
}
rm(fireball)