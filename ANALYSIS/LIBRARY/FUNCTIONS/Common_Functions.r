#*******************************************************************************
#
#-- Author: P Campbell-Burns, UKMON
#
#-- Description:
#
#   Common functions:
#
#   - Runscript         (run an external script with output to jpeg or PDF)
#   - get_stream        (prompt user for a list of streams)
#   - get_year          (Prompt user for year)
#   - read_ufo          (Read UFO Orbit data file)
#   - filter_stream     (Filter input data frame by type, stream, and year)
#   - get.bin.counts    (Frequency distribution with variable bin size)
#   - filter_apply_qa   (Apply QA filter)
#
#-- Shared under the Creative Common  Non Commercial Sharealike 
#   License V4.0 (www.creativecommons.org/licebses/by-nc-sa/4.0/)
#
#-- Version history:
#
#   Vers  Date    Notes
#   ----  ----    -----
#   1.1   20/09/2016  Added Quality Criteria filter function
#   1.0   15/11/2015  First release
#
#
#*******************************************************************************




Runscript <- function(Scriptfile,Otype=NA, orient="port") {
#===============================================================================
#
#-- Runs Scriptfile using source command, directing output as specfied
#-- by otype.  Orientation set by orient parameter.  Page sizes are defined
#-- in the configuration file.
#
#===============================================================================
# Define Output Macro which runs script setting output, page orientation 
# and plot size
    
    wd = orient[Otype,]$width
    ht = orient[Otype,]$height
    pp = orient[Otype,]$papr

    Ofile = sub("\\.R","\\.r",Scriptfile)
	Ofile = sub("\\.r",paste("_",SelectStream,"_",SelectYr,sep=""),Ofile)

    if (Otype=="JPG") jpeg(paste(ReportDir,"/",Ofile,".jpg",sep=""), 
		    width = wd, height = ht, 
            units = "px", res=150, pointsize = 12, quality = 100, bg = "white")
    
    if (Otype=="PDF") pdf(paste(ReportDir,"/",Ofile,".pdf",sep=""),onefile=TRUE, paper=as.character(pp), 
            width = wd, height = ht)
        
	source(paste(PlotDir,Scriptfile,sep="/"))
	dev.off(which=dev.cur())
 
}


get_stream <- function(mu) {
#===============================================================================
#
#-- Presents a menu of stream IDs based on stream IDs in data frame mu
#
#===============================================================================
#-- prompt user for a list of streams; stream options are those
#-- streams found in input dataframe.  Returns atributes from lookup
#-- table (full name, activity, peak)
    
    AStreams <- unique(mu$X_stream, incomparables = FALSE, fromLast = FALSE,nmax = NA)
 
# Read stream data from config file 

    streamnames = paste(RefDir,"streamnames.csv",sep="/")
    lookup <- read.csv(streamnames, header=TRUE)
    lookup <- subset(lookup,code == "ALL" | code %in% AStreams)
    Streamlist <- as.vector(paste(lookup[,1],"   (",lookup[,2],")",sep=""))

# Prompt user for stream (listing only streams in the data file)

    i <- menu(Streamlist, graphics=TRUE, title="Choose stream")
    if (i==0) stop("No stream selected")

# Extract stream attributes from config file

    SelectStream = as.character(lookup[i,1])

    stream <- rbind(as.character(lookup[i,1]), paste("(",as.character(lookup[i,2]),")",sep=""),as.numeric(lookup[i,5]), as.character(lookup[i,6]), as.character(lookup[i,7]))

    return (stream)
}



get_year <- function(mu) {
#===============================================================================
#
#-- Presents a menu of years based on date range in data frame mu
#
#===============================================================================
#-- Get year; options include only those years in the input data frame
    Years <- unique(substring(mu$X_localtime,1,4), incomparables = FALSE, fromLast = FALSE,nmax = NA)
    Years <- sort(Years)
    Years <- c("ALL",Years)
# Promt user for year of year of report

    i <- menu(Years, graphics=TRUE, title="Choose year")
    
    if (i==0) stop("No year selected")
    
    return(as.character(Years[i]))
}



read_ufo <- function(mx) {
#===============================================================================
#
#-- Presents file picker filtered for CSV files (if no preconfigured input file)
#-- Ingests file
#-- Standardises data
#
#===============================================================================

# - Read UFO Orbit data file
    
# setup filter
    filt <- matrix(c("Comma separated / Excel files","*.csv"), 
            nrow = 1, ncol = 2, byrow = TRUE,
            dimnames = list(c("csv"),c("V1","V2")))
    
if (is.na(SourceUnified)) {
        infile <- choose.files(caption = "Select UFO Orbit Unified file",multi = FALSE,filters=filt)
	} else {
        infile <- paste(DataDir,SourceUnified,sep="/")
	}

cat(paste("Ingesting UFO data file:",infile,"\n"))

if (infile == "") stop

# --- Read the UFO data file

# Read raw data
    mt <- read.csv(infile, header=TRUE)

# Standardise ID1
    mt$X_ID1<- substring(mt$X_ID1,2)

# standardise localtime
    mt$X_localtime <- as.POSIXct(strptime(mt$X_localtime, "_%Y%m%d_%H%M%S"))

# remove NA localtimes if any
    mt <- subset(mt, ! is.na(X_localtime))

# Standardise streamname
    mt$X_stream <- toupper(ifelse(substring(mt$X_stream,1,2)=="_J",substring(mt$X_stream,5),substring(mt$X_stream,2)))

    cat(paste("Rows ingested:",nrow(mt),"\n"))

return (mt)

}

filter_stream <- function(mx, mstream="ALL", myr="ALL", mtype="UNIFIED") {
#===============================================================================
#
#-- Filters input data frame mx for all meteors meeting selection criteria
#-- (stream and year)
#
#===============================================================================
#-- Filter input data frame by type (e.g. unified), stream, and year
    cat(paste("Filtering input for stream:",mstream,", year:", myr,", type:",mtype,"\n"))
    if (mtype == "UNIFIED") {
	my <- subset(mx, substring(X_ID1,2,8) == "UNIFIED")
	my$X_ID1[nchar(my$X_ID1) == 11] <- sub("D_","D_0",my$X_ID1[nchar(my$X_ID1) == 11])
	}

    if (mtype != "UNIFIED") my <- subset(mx, substring(X_ID1,2,8) != "UNIFIED")

    if (mstream != "ALL")  my <- subset(my, X_stream == mstream)
    if (myr     != "ALL")  my <- subset(my, substring(my$X_localtime,1,4) == myr)
    cat(paste(mtype,"rows:",nrow(my),"\n"))    
    return (my)

}


get.bin.counts = function(x, name.x = "x", start.pt, end.pt, bin.width){
#===============================================================================
#
#-- Binning of frequency counts
#	x - entity to be counted
#	start.pt - start bin value
#	end.pt - end bin value
#	bin.width - width of bin
#	name - name of count column in returned data frame
#
#===============================================================================
    br.pts = seq(start.pt, end.pt, bin.width)
    x = x[(x >= start.pt)&(x <= end.pt)]
    counts = hist(x, breaks = br.pts, plot = FALSE)$counts
    dfm = data.frame(br.pts[-length(br.pts)], counts)
    names(dfm) = c(name.x, "freq")
    return(dfm)
}


filter_apply_qa <- function(mx, QA_e=1, QA_dv12=7.0, QA_GM=80.0, QA_Dur=0.1, QA_QA=0.15, QA_Qo=1.0, QA_Qc=10.0, QA_Delta_GP=0.5, QA_H1=200, QA_H2=20 ) {
  #===============================================================================
  #
  #-- Filters input data frame mx for all meteors meeting quality criteria
  #
  #===============================================================================
  #-- Filter input data frame by type (e.g. unified), stream, and year
  n_start <- nrow(mx)
  cat("\n")
  cat(paste("QA filtering:\n")) 
  cat(paste("=============\n"))    
  my<-subset(mx, X_e <= QA_e & X_QA >= QA_QA & abs(mx$X_dv12) <= QA_dv12 & abs(mx$X_Gm) >= QA_GM & X_dur >= QA_Dur & X_H1 <= QA_H1 & X_H2 >= QA_H2 & X_Qo >= QA_Qo & X_Qc >= QA_Qc )
  cat(paste("- e    < ",QA_e,   "\n"))   
  cat(paste("- dc12 <=",QA_dv12,"\n")) 
  cat(paste("- GM   >=",QA_GM,  "\n"))  
  cat(paste("- Dur  >=",QA_Dur ,"\n")) 
  cat(paste("- QA   >=",QA_QA,  "\n"))  
  cat(paste("- Qo   >=",QA_Qo,  "\n")) 
  cat(paste("- Qc   >=",QA_Qc,  "\n"))  
  cat(paste("- H1   <=",QA_H1,  "\n"))  
  cat(paste("- H2   >=",QA_H2,  "\n\n")) 
  n_end <- nrow(my)
  pct = 0
  if (n_end != 0) {pct = (100*n_end/n_start)}
  cat(paste("Rows out:",n_end,", ", round( 100 - pct ,digits=1),"% loss.\n"))    
  return (my)
  
}