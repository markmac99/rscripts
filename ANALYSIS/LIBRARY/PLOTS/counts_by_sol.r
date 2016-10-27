# =================================================================
#
#-- Author: Peter Campbell-Burns, UKMON
#-- Version 1.0, 12/12/2015
#
#-- Scan for fireballs from single and unified observations
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

dfm = get.bin.counts(mu$X_sol, name.x = "sol", 
                     start.pt = 0,
                     end.pt = 360, 
                     bin.width = 1)

dfx = as.vector(dfm$freq)

dbgraph = barplot (dfx, 
                       xlab="Solar Longitude",
                       ylab="Counts",
                       main=paste("Counts by Solar Longitude \n"),
                       sub=DataSet,
                       col="blue",
                       border=NA)
axis(1, at = dbgraph,labels=1:360, cex.axis=0.8)

rm(dfm)
rm(dfx)
rm(dbgraph)
