# =================================================================
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

Binsize = c(0.1, 0.2, 0.3, 0.4, 0.5, 0.6)
Upperlim = 100

MainTitle = paste("Frequency distribution of a",")\n",Streamname)
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
    tmp <- subset(mu, X_a >=0 & X_a <= Upperlim)
    Scr = 1
plot.new()


split.screen(c(3,2))

    for (z in Binsize) {
        screen(Scr)
        par(mar=c(4,5,1.5,1.5),oma=c(3,1,4,1))
        dfm = get.bin.counts(tmp$X_a, name.x = "a", 
                             start.pt = 0,
                             end.pt = Upperlim+1, 
                             bin.width = z)
        plot(dfm$a, dfm$freq, 
             type="s", 
             lwd=1, 
             lty=1, 
             pch=18, 
             xaxt = "n", 
             col="red", 
             xlab=paste("Bin size:",z), 
             ylab="Count")
        axis(1, at = seq(0, 100, 10))
  
Scr = Scr + 1
    
}

# Display plot Axis

# title(main=MainTitle, cex.main=1.1,outer=TRUE) 
mtext(MainTitle,side=3,cex=1,line=0,outer=TRUE) 
close.screen(all = TRUE)

rm(tmp)
rm(dfm)
