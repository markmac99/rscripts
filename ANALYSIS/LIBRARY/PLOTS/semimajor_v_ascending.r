#------------------------------------------------------
#
#-- Scatterplot showing semi-major axis vs ascening node
#
#-- Author: Peter Campbell-Burns, UKMON
#-- Version 1.0, 12/12/2015
#
#-- Shared under the Creative Common  Non Commercial Sharealike 
#   License V4.0 (www.creativecommons.org/licebses/by-nc-sa/4.0/)
#
#------------------------------------------------------

par(mai=c(1.2,1.0,1.7,0.5))

# Exclude negative (Hyperbolic) a

mf <- mu[mu$X_a >=0,]

if (nrow(mf) > 0 ) {
  
  # Select and configure the output device
  select_dev(Outfile, Otype=output_type, wd= paper_width, ht=paper_height, pp=paper_orientation)
  
  
  plot(mf$X_node, 
       mf$X_a, 
       ylim=c(0,40), 
       xlim=c(0,350), 
       ylab="Semi-major Axis (AU)", 
       xlab="Longitude of the Ascending Node (Deg)", 
       pch=20, 
       cex=0.6,
       main=paste("Longitude of Ascending Node vs Semi-major axis \n",Streamname),
       sub=DataSet) 
  
} else {
  cat(" *** No data")
}
# Tidy Up
rm(mf)
