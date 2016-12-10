
#------------------------------------------------------
#-- Author: Peter Campbell-Burns, UKMON
#-- Version 1.0, 12/12/2015
#
#-- Distribution of distance from catalogue 
#   Radiant position plotted RA vs Dec
#
#-- Shared under the Creative Common  Non Commercial Sharealike 
#   License V4.0 (www.creativecommons.org/licebses/by-nc-sa/4.0/)
#
#
#------------------------------------------------------

# Select and configure the output device
select_dev(Outfile, Otype=output_type, wd= paper_width, ht=paper_height, pp=paper_orientation)

abs_dr <- abs(mu$X_dr)
bins=seq(0,as.integer(max(abs(abs_dr)))+1,by=0.2)

# Select and configure the output device
select_dev(Outfile, Otype=output_type, wd= paper_width, ht=paper_height, pp=paper_orientation)

hist(abs_dr,
     breaks=bins,
     col="blue", 
     xlab="Distance (degrees)",
     ylab="count",
     xlim = c(0,as.integer(max(abs_dr))+1),
     main=paste("Distance from Radiant",Streamname),
     sub=DataSet)

rm(bins)


