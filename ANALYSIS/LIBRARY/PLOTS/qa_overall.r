# =================================================================
#
#-- Distribution of quality metric QA
#
#-- Author: Peter Campbell-Burns, UKMON
#-- Version 1.0, 12/12/2015
#
#-- Shared under the Creative Common  Non Commercial Sharealike 
#   License V4.0 (www.creativecommons.org/licebses/by-nc-sa/4.0/)
#
#
# =================================================================

# Set-up JPEG

par(mar=c(2.0,2.0,3.0,2.0))
plot.new()


MainTitle = paste("QA for Single Station Obs.\n",Streamname)
SubTitle  = DataSet

split.screen(c(1,2))

screen(1)

h = hist(ms$X_QA,
     main=MainTitle,
     cex.main=0.7,
     xlab = "QA",
     ylab = "Counts",
     breaks=20,
     border=FALSE,
     plot = TRUE,
     freq=TRUE,col="blue")

screen(2)
MainTitle = paste("QA for Unified Obs.\n",Streamname)
h = hist(mu$X_QA,
         main=MainTitle,
         cex.main=0.7,
         xlab = "QA",
         ylab = "Counts",
         breaks=20,
         border=FALSE,
         plot = TRUE,
         freq=TRUE,col="blue")

close.screen(all = TRUE)

rm(h)




    
