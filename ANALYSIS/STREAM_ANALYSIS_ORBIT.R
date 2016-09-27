#=============================================================================
#
#-- Author: P Campbell-Burns, UKMON
#
#
#-- Description:
#
#   This script compares a UFO ORBIT extract of UNIFIED observations with a selected
#   reference orbit and plots a histogram of the D_Criterion values (limited by the D_Threshold
#   value cutoff in the reference data)
#
#   Environment varables are set by script Lib_Config.r which sets pointers
#   to source data, directory holding the scripts, directory recieving reports
#   etc. This file must be first configured to match the installation.
#
#   Note, the distribution (ANALYSIS folder) must be held in My Documents
#
#-- Shared under the Creative Common  Non Commercial Sharealike 
#   License V4.0 (www.creativecommons.org/licebses/by-nc-sa/4.0/)
#
#-- Version History
# 
#   Vers  Date          Notes
#   ----  ----          -----
#   1.0   03/12/2015    First release
#
#=============================================================================

# Initialise environment variables and common functions

source("~/ANALYSIS/CONFIG/Lib_Config.r")
source(paste(FuncDir,"/common_functions.r",sep=""))
source(paste(FuncDir,"/D_Criteria.r",sep=""))
source(paste(FuncDir,"/Orbit_3D.r",sep=""))
source(paste(FuncDir,"/Orbital_Elements.r",sep=""))


# Set the R working directory (this is where R saves its environment)

setwd(WorkingDir)

ref_orbit <- get_elements(Perseids)[1,]

stream_name <- ref_orbit[1,"stream_name"]
stream_name <- levels(stream_name)
e           <- ref_orbit[1,"e"]
q           <- ref_orbit[1,"q"]
i           <- ref_orbit[1,"i"]
n           <- ref_orbit[1,"n"]
p           <- ref_orbit[1,"p"]
d_threshold <- ref_orbit[1,"d_threshold"]

# Read UNIFIED CSV file created by UFO Orbit (all columns are read) and standardise data

mt <- read_ufo()
rows_read <- nrow(mt)
if (rows_read == 0) {
  stop("No data in input file")
}

cat(paste("*** Rows read from input file",as.character(rows_read),"\n"))

# Select which stream / year to process
#   SelectYr <- get_year(mt)

# Get UNIFIED and Single observations

mu <- filter_stream(mt, mtype="UNIFIED")
if (nrow(mu) == 0) {
  stop("No data in UNIFIED dataframe")
}

# Apply Quality Criteria

z <- filter_apply_qa(mu)

# Add new column to hold stream identification
z["Stream"] <- "UNMATCHED"

# Perform D_Criterion analysis
DType <- "DD"
z<-DCalc(z, e,q,i,n,p,D_Type=DType)

# Set stream identification where D_Value is les than threshold

a = which(z["D_Value"]<=d_threshold )
if (length(a) > 0) {
  z[a,"Stream"] <- stream_name
}
cat( paste("Number of", stream_name,":", nrow(z[z$Stream == stream_name,]) ))

#-- Create D_Criterion plot 

rng = d_threshold + 0.1
plot.new()
hist(z$D_Value[a], col="blue",
     main = paste(DType, "Criteria match against",stream_name),
     breaks = c(seq(0,rng,0.005)),
     xlab = paste(DType, "value"),xlim=c(0,rng))

    library(rgl)

#-- Plot orbits where Stream maches reference data 

    rgl.open()
    rgl.clear()
    rgl.bg(color="lightblue")

     l_len = max(z[z$Stream==stream_name,"X_a"])
    rgl.lines(c(-l_len,l_len),c(0,0), c(0,0), color="black")
    rgl.lines(c(0,0), c(-l_len,l_len),c(0,0),  color="black")
    rgl.lines(c(0,0), c(0,0), c(-l_len,l_len), color="black")

    a = orbit(Mercury_Orbit())
    lines3d(x=a[,1], y=a[,2], z=a[,3], col="red", size=0.01,xlab ='X',ylab ='Y',zlab ='Z',
            xlim=c(-3,3), ylim=c(-3,3), zlim=c(-3,3), add = FALSE) 
    
    a = orbit(Venus_Orbit())   
    lines3d(x=a[,1], y=a[,2], z=a[,3], col="darkblue", size=0.01,xlab ='X',ylab ='Y',zlab ='Z',
            xlim=c(-3,3), ylim=c(-3,3), zlim=c(-3,3), add = TRUE) 
    
    a = orbit(Earth_Orbit())   
    lines3d(x=a[,1], y=a[,2], z=a[,3], col="green", size=0.01,xlab ='X',ylab ='Y',zlab ='Z',
            xlim=c(-3,3), ylim=c(-3,3), zlim=c(-3,3), add = TRUE ) 
    
    i_plot = 0    
    for (idx in 1:nrow(z)) { 
    
      if (z$Stream[idx] == stream_name & z$D_Value[idx] <= 0.7 ) {
        # Elements: a, e, I, O, w, M
        orb_elements =c(z$X_a[idx], z$X_e[idx], z$X_incl[idx], z$X_peri[idx], z$X_node[idx],100) 
        a = orbit(orb_elements)
        add_flag <- ifelse(idx==1,TRUE, FALSE)
        i_plot = i_plot + 1
        lines3d(x=a[,1], y=a[,2], z=a[,3], col="red", size=0.1,xlab ='X',ylab ='Y',zlab ='Z',
            xlim=c(-3,3), ylim=c(-3,3), zlim=c(-3,3), add = add_flag) 
      }
    }
    cat(i_plot,"orbits plotted")
    