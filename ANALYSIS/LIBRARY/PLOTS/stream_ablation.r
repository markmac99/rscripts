# =================================================================
#
#-- Plot showing ablation zone (H1 to H2)
#
#-- Author: Peter Campbell-Burns, UKMON
#-- Version 1.0, 12/12/2015
#
#-- Shared under the Creative Common  Non Commercial Sharealike 
#   License V4.0 (www.creativecommons.org/licebses/by-nc-sa/4.0/)
#
#
# =================================================================

par(mai=c(1.2,0.9,1.2,0.3))

# Get start (h1) and end (H2) height

tmp <- mu[,c("X_H1","X_H2")]

# Exclude out of (sensible) range data ( H . 140km and H < 0)

tmp <- tmp[tmp$X_H1 < 140 & tmp$X_H2 > 0 & tmp$X_H1 > tmp$X_H2,]

if (nrow(tmp) > 0 ){
    
    # Select and configure the output device
    select_dev(Outfile, Otype=output_type, wd= paper_width, ht=paper_height, pp=paper_orientation)
  
    # Order by decreasing H1 then H2
    
    ab_sort <-tmp[order(-tmp$X_H1,-tmp$X_H2),]
    
    # Set altitude difference A1 as (max H1 + margin) - H1  (Plot altitude to ablation zone start)
    
    ab_sort$A1 <- (max(ab_sort$X_H1) + 10) - ab_sort$X_H1
    
    # Set altitude difference A2 as H1 - H2  (Start of ablation zone to end of ablation zone)
    
    ab_sort$A2 <- ab_sort$X_H1 - ab_sort$X_H2
    
    # Set altitude difference A3 as H2  end of ablation zone to ground)
    
    ab_sort$A3 <- ab_sort$X_H2
    
    # Convert to matrix for plotting
    
    x <- data.matrix(t(ab_sort[,c("A3","A2","A1")]))
    
    # ... and plot
    
    barplot(x,
        xlab="Individual observations", 
        las=1, col=c("darkblue","red","darkblue"),
        cex.names=0.7,
        border=NA,
        beside =FALSE, 
        axisnames=FALSE,
        space=0,
        ylim=c(0,max(ab_sort$X_H1)),
        ylab="Start (H1) and end (H2) ablation altitude in km",
        main=paste("Meteor ablation",Streamname),
        sub = DataSet)
    
    	
    # Tidy Up
    rm(x)
    rm(ab_sort)
}

rm(tmp)
                  



