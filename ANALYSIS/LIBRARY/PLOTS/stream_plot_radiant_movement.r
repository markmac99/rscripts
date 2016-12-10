#------------------------------------------------------
#
#-- Mupti-chart plot showing movement of radiant
#
#-- Author: Peter Campbell-Burns, UKMON
#-- Version 1.0, 12/12/2015
#
#-- Shared under the Creative Common  Non Commercial Sharealike 
#   License V4.0 (www.creativecommons.org/licebses/by-nc-sa/4.0/)
#
#------------------------------------------------------

# Select and configure the output device

select_dev(Outfile, Otype=output_type, wd= paper_width, ht=paper_height, pp=paper_orientation)
par(oma=c(2,2,2,1))
par(mar=c(2,2,2,1))
plot.new()

# Setup screens
split.screen(c(1,2))
split.screen(c(2,1),screen=1)

screen(3)

plot(mu$X_sol, 
     mu$X_ra_t, 
     main=paste("Solar Long. vs RA",Streamname), 
     ylab="RA (modified)", 
     xlab="Solar Longitude", 
     pch=20,
     cex = 0.3,
     cex.main = 1.0,
     cex.lab=0.8,
     cex.axis=0.8,
     cex.sub = 0.8,
     sub=paste(DataSet))

screen(4)

plot(mu$X_sol, 
     mu$X_dc_t, 
     main=paste("Solar Long. vs Dec",Streamname), 
     ylab="Dec (modified)", 
     xlab="Solar Longitude", 
     pch=20,
     cex = 0.3,
     cex.main = 1.0,
     cex.lab=0.8,
     cex.axis=0.8,
     cex.sub = 0.8,
     sub=paste(DataSet)) 

screen(2)

library(scatterplot3d)
scatterplot3d(mu$X_sol,mu$X_ra_t,mu$X_dc_t,
              ylab="Ra (modified)", 
              xlab="Dec (modified)",
              zlab="Solar Longitude",
              cex = 0.3,
              cex.main = 1.0,
              cex.lab=0.8,
              cex.axis=0.8,
              cex.sub = 0.8,
              main=paste("Solar Long vs RA and Dec",Streamname), 
              sub=paste(DataSet)
	      )
close.screen(all = TRUE)
