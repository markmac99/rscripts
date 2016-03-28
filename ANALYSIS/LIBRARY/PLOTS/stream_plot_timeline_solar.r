# =================================================================
#
#-- Line plot of counts vs solar longitude
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

MainTitle = paste("Observed stream activity (Interval",as.character(SelectIntervalSol),"deg)",Streamname)
SubTitle  = paste("Dataset period: Sol",round(Solpeak-0.4,digits=2),"to Sol",round(Solpeak+0.4,digits=2))

binsize=0.005

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

# Plot meteor counts by individual stations
   
    dfm = get.bin.counts(mu$X_sol, name.x = "time", 
                         start.pt = Solpeak-0.4,
                         end.pt = Solpeak+0.4, 
                         bin.width = SelectIntervalSol)
    maxy = max(maxy,max(dfm$freq))  

    plot(dfm$time, dfm$freq, type="l", lwd=1, lty=1, pch=18, col="blue", ylim=c(0,maxy+1), xlab="Solar Longitude", ylab="Count")
# Display plot Axis

title(main=MainTitle, sub=SubTitle) 

rm(dfm)
