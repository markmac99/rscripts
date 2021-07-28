# =================================================================
#
#-- Line plot of counts vs date/time
#
#-- Author: Peter Campbell-Burns, UKMON
#-- Version 1.0, 12/12/2015
#
#-- Shared under the Creative Common  Non Commercial Sharealike 
#   License V4.0 (www.creativecommons.org/licebses/by-nc-sa/4.0/)
#
#
# =================================================================

# These paramaters set plot title

MainTitle = paste("Observed stream activity (",SelectInterval/60," minute intervals) ",Streamname,sep="")
SubTitle  = paste("Dataset period:",SelectStart,"to",SelectEnd)

# Create function to 'bin' by time

get.bin.counts = function(x, name.x = "x", start.pt, end.pt, bin.width){
    br.pts = seq(start.pt, end.pt, bin.width)
    x = x[(x >= start.pt)&(x <= end.pt)]
    counts = hist(x, breaks = br.pts, plot = FALSE)$counts
    dfm = data.frame(br.pts[-length(br.pts)], counts)
    names(dfm) = c(name.x, "freq")
    return(dfm)
}

#  Initialise

maxy = 0
Idx = 0

# Select and configure the output device
select_dev(Outfile, Otype=output_type, wd= paper_width, ht=paper_height, pp=paper_orientation)

# Plot meteor counts by individual stations
if (singletype == "UNIFIED"){
    dfm = get.bin.counts(ms$X_localtime, name.x = "time", 
                         start.pt = as.POSIXct(SelectStartSingle),
                         end.pt = as.POSIXct(SelectEndSingle), 
                         bin.width = SelectInterval)
}else{
    dfm = get.bin.counts(ms$LocalTime, name.x = "time", 
                         start.pt = as.POSIXct(SelectStartSingle),
                         end.pt = as.POSIXct(SelectEndSingle), 
                         bin.width = SelectInterval)

}
    maxy = max(maxy,max(dfm$freq))
    plot(dfm$time, dfm$freq, type="l", lwd=1, lty=1, pch=18, xaxt = "n", col="blue", ylim=c(0,maxy+1), xlab="Time", ylab="Count")


# Display plot Axis

axis.POSIXct(1, at = seq(min(dfm$time), max(dfm$time), by="days"), labels=FALSE)
axis.POSIXct(1, at = seq(min(dfm$time), max(dfm$time), by ="hours"), tcl = -0.2)
title(main=MainTitle, sub=SubTitle) 

rm(maxy)
rm(dfm)

