# =================================================================
#
#-- Author: Peter Campbell-Burns, UKMON
#-- Version 1.0, 12/12/2015
#
#-- Histogram of ascending node
#
#-- Shared under the Creative Common  Non Commercial Sharealike 
#   License V4.0 (www,creativecommons.org/licebses/by-nc-sa/4.0/)
#
#
# =================================================================

# These paramaters set plot title

Binsize = 0.2
Upperlim = 100

MainTitle = paste("Frequency distribution of Semi-Major Axis (bin size",Binsize,")\n",Streamname)
SubTitle  = DataSet

# Create function to 'bin' by time

get.bin.counts = function(x, name.x = "x", start.pt, end.pt, bin.width){
    br.pts = seq(start.pt, end.pt, bin.width)
    x = x[(x >= start.pt)&(x <= end.pt)]
    counts = hist(x, breaks = br.pts, plot = FALSE)$counts
    dfm = data.frame(br.pts[-length(br.pts)], counts)
    names(dfm) = c(name.x, "freq")
    return(dfm)
}
    tmp <- subset(mu, X_a >=0 & X_a <= Upperlim)
    dfm = get.bin.counts(tmp$X_a, name.x = "a", 
                         start.pt = 0,
                         end.pt = Upperlim, 
                         bin.width = Binsize)

    # Select and configure the output device
    select_dev(Outfile, Otype=output_type, wd= paper_width, ht=paper_height, pp=paper_orientation)
    par(mar=c(4,4,3,1), oma=c(4,1,3,1))
    plot.new()
    plot(dfm$a, dfm$freq, 
         type="s", 
         lwd=1, 
         lty=1, 
         pch=18, 
         xaxt = "n", 
         col="red", 
         xlab="Semi-major Axis (au)", 
         ylab="Count") 

# Display plot Axis

axis(1, at = seq(0, 100, 10))
title(main=MainTitle, cex.main=1.1,outer=TRUE) 
mtext(SubTitle,side=1,cex=0.8,line=0,outer=TRUE) 

rm(tmp)
rm(dfm)
