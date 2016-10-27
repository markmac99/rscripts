# =================================================================
#
#-- Plot meteor stream duration
#
#-- Author: Peter Campbell-Burns, UKMON
#-- Version 1.0, 12/12/2015
#
#-- Shared under the Creative Common  Non Commercial Sharealike 
#   License V4.0 (www.creativecommons.org/licebses/by-nc-sa/4.0/)
#
#
# =================================================================


par(mai=c(1.0,1.5,0.5,1.0))

nobs <- nrow(mu)
if (nobs < 10) {
  brks = 5
} else if ( nobs < 1000 ) {
  brks = 50
} else if ( nobs < 5000 ) {
  brks = 200
} else {
  brks = 500
}

bgraph <- hist(mu$X_dur , 
               xlab="Duration of meteor (in seconds)",
               ylab="Count",
               main=paste("Meteor Duration\n"),
               breaks = brks,
               xlim = range(0,5),
               sub=DataSet)

rm(bgraph)
rm(nobs)
rm(brks)
