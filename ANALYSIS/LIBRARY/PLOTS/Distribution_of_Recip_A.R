# =================================================================
#
#
#-- Author: Peter Campbell-Burns, UKMON
#-- Version 1.0, 12/12/2015
#
#-- Shared under the Creative Common  Non Commercial Sharealike 
#   License V4.0 (www.creativecommons.org/licebses/by-nc-sa/4.0/)
#
#
# =================================================================

# Look for fireball magnitudes



get.bin.counts = function(x, name.x = "x", start.pt, end.pt, bin.width){
    br.pts = seq(start.pt, end.pt, bin.width)
    x = x[(x >= start.pt)&(x <= end.pt)]
    counts = hist(x, breaks = br.pts, plot = FALSE)$counts
    dfm = data.frame(br.pts[-length(br.pts)], counts)
    names(dfm) = c(name.x, "freq")
    return(dfm)
}

dfm = get.bin.counts(1 / mu$X_a, name.x = "sol", 
                     start.pt = 0,
                     end.pt = 1.005, 
                     bin.width = 0.005)

dfx = as.vector(dfm$freq)

dbgraph = barplot (dfx,
                       xlab="1 / a",
                       ylab="Counts",
                       main=paste("Distribution of 1/a",Streamname," \n",sep=" "),
                       sub=DataSet,
                       col="blue",
                       border=NA)
axis(1, at = pretty(dbgraph,n=50),labels=seq(0,0.998,.02), cex.axis=0.7, las=2)

rm(dfm)
rm(dfx)
rm(dbgraph)