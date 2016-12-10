# =================================================================
#
#-- Plot of difference in Vo between station and unified data
#   (as a quality metric)
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

par(mar=c(4,1.0,2,0.5))

MainTitle = paste("Difference in Vo between station and unified data",Streamname)
SubTitle  = DataSet

# Restrict velocity to prevent range problems

msu <- subset(ms, ms$X_dv12. >= -20 & ms$X_dv12. <= 20)

if (nrow(msu) > 0) {
  
    # Select and configure the output device
    select_dev(Outfile, Otype=output_type, wd= paper_width, ht=paper_height, pp=paper_orientation)
  
    h = hist(msu$X_dv12.,
         main=MainTitle,
         cex.main=0.8,
         xlab = "% difference in velocity",
         ylab = "Counts",
         sub=SubTitle,
         breaks=20,
         border=FALSE,
         plot = TRUE,
         freq=TRUE,col="blue")
    
    text(10,max(h$counts)/2,paste("SD =    ", round(sd(msu$X_dv12.), digits=3),"\n", 
                 "Mean =",round(mean(msu$X_dv12.), digits=3),sep=""),
                 cex = 0.7,adj=c(0,0))
    
    rm(h)
    
} else {
    cat(" *** No data ")
  }
rm(msu)




    
