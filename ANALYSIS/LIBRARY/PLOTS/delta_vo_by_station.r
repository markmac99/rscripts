# =================================================================
#
#-- Distribution of Diferences in station and unified Vo
#   (as a quailty metric)
#
#-- Author: Peter Campbell-Burns, UKMON
#-- Version 1.0, 12/12/2015
#
#-- Shared under the Creative Common  Non Commercial Sharealike 
#   License V4.0 (www.creativecommons.org/licebses/by-nc-sa/4.0/)
#
#
# =================================================================


Idx=0

Plot_Rows = 3
Plot_Cols = 4
oldpar <- par(mfrow=c(Plot_Rows,Plot_Cols))
par(mar=c(2.5,1,2,1), oma=c(1,1,3,1))

MainTitle = paste("Diference in station and unified Vo",Streamname)
SubTitle  = DataSet

# Restrict velocity to prevent range problems

statcount <- table(ms$X_ID1)
statcount = as.data.frame(statcount)
stationlist <- statcount$Var1 
stationlist <- sort(stationlist)

for (x in stationlist)    
{
    Idx = Idx + 1
    tmp <- subset(ms, ms$X_ID1 == x & ms$X_dv12. >= -20 & ms$X_dv12. <= 20)
    h = hist(abs(tmp$X_dv12.),
        main = x,
        xlab = "% delta V0",
        ylab = "Counts",
        cex.main = 0.8,
        cex.axis = 0.9,
        breaks=20,
        border=FALSE,
        plot = TRUE,
        freq=TRUE,col="blue")
    
    if (Idx==1) {
        stats <- data.frame(x,min(tmp$X_dv12.),max(tmp$X_dv12.),mean(tmp$X_dv12.),sd(tmp$X_dv12.)) 
    } else {
        stats <- rbind(stats,data.frame(x,min(tmp$X_dv12.),max(tmp$X_dv12.),mean(tmp$X_dv12.),sd(tmp$X_dv12.))) 
    }
}

par(oldpar)

colnames(stats) <- c("station","min","max","mean","sd")
outfile = paste(ReportDir,"/TABLE_Delta_Vo_by_station_",SelectStream,"_",SelectYr,".csv",sep="")
write.csv(stats,outfile)

par(mfrow=c(1,1))
rm(Plot_Rows)
rm(Plot_Cols)
rm(h)
rm(tmp)
rm(stationlist)
rm(statcount)
    
