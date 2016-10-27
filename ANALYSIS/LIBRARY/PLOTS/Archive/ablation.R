# =================================================================
#
# Plot of meteor ablation for selected stream / year
#
#-- Author: Peter Campbell-Burns, UKMON
#-- Version 1.0, 12/12/2015
#
# 
#
# =================================================================

# Get start (h1) and end (H2) heights

tmp <- mu[,c("X_H1","X_H2")]

# Order by decreasing H1 then H2

ab_sort <-tmp[order(-ablation$X_H1,-ablation$X_H2),]

# Set altitude difference A1 as (max H1 + margin) - H1  (Plot altitude to ablation zone start)

ab_sort$A1 <- (max(ab_sort$X_H1) + 10) - ab_sort$X_H1

# Set altitude difference A2 as H1 - H2  (Start of ablation zone to end of ablation zone)

ab_sort$A2 <- ab_sort$X_H1 - ab_sort$X_H2

# Set altitude difference A3 as H2  end of ablation zone to ground)

ab_sort$A3 <- ab_sort$X_H2

# Convert to matrix for plotting

x <- data.matrix(t(ab_sort[,c("A3","A2","A1")]))

# ... and plot

barplot(x,main=paste("Meteor ablation",Streamname),
        sub=DataSet,
        xlab="Individual observations", 
        las=1,
        col=c("darkblue","red","darkblue"),
        cex.names=0.7,
        border=NA,
        beside =FALSE, 
        axisnames=FALSE,
        space=0,
        ylim=c(0,max(ab_sort$X_H1)),
        ylab="Start (H1) and end (H2) ablation altitude in km")




