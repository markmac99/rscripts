# =================================================================
#
#-- Scan for fireballs from single and unified observations
#
#-- Shared under the Creative Common  Non Commercial Sharealike 
#   License V4.0 (www.creativecommons.org/licebses/by-nc-sa/4.0/)
#
#
# =================================================================

# Look for fireball magnitudes
fireball <- mu[mu$X_mag <= -4, c("X_localtime","X_mag","X_ID1","X_stream")]


if (nrow(fireball) > 0 ) {
  
    # Select and configure the output device
    select_dev(Outfile, Otype=output_type, wd= paper_width, ht=paper_height, pp=paper_orientation)
  
    fireball$X_month <- as.integer(substring(fireball$X_localtime,6,7))
    counts <- tabulate(fireball$X_month, nbins=12)
    
    bgraph = barplot (counts,  names.arg=c("J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D"),
                      xlab="Month",
                      ylab="Counts",
                      las=1, 
                      col=c("lightblue","lightblue","lightblue","darkblue","darkblue","darkblue","lightgreen","lightgreen","lightgreen","darkgreen","darkgreen","darkgreen"),
                      main=paste("Fireball count by month \n"),
                      sub=DataSet)
    
    
    text( bgraph, counts, labels=counts,pos=3, offset=0.2,adj=c(0,0),xpd=NA)
    
    rm(counts)
    rm(bgraph)
    
} else {
  cat("No fireballs identified in data")
}
rm(fireball)