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
#   - match_stream      find a stream given its TLA
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
#   1.2   09/02/2016  Changes to improve MacOS compatibility
#   1.1   20/09/2016  Added Quality Criteria filter function
#   1.0   15/11/2015  First release
#
#
#*******************************************************************************

library(tcltk)

Set_Outfile <- function(Scriptfile, Yr = "NONE", Stream = "NONE") {
  #===============================================================================
  # Set directory and name of output file - create directories if needed
  #===============================================================================  
  Ofile = sub("\\.R", "\\.r", Scriptfile)
  Ofile = sub("\\.r", "", Scriptfile)
  Path1 = file.path(ReportDir, Yr)
  dir.create(Path1, showWarnings = FALSE)
  Path2 = file.path(Path1, Stream)
  dir.create(Path2, showWarnings = FALSE)
  return(paste(Path2, "/", Ofile, sep = ""))
}


Runscript <- function(Scriptfile, Otype = NA, orient = "port") {
  #===============================================================================
  #
  #-- Runs Scriptfile using source command, directing output as specfied
  #-- by otype.  Orientation set by orient parameter.  Page sizes are defined
  #-- in the configuration file.
  #
  #===============================================================================
  # Define Output Macro which runs script setting output, page orientation 
  # and plot size

  output_type = Otype
  paper_width = orient[Otype,]$width
  paper_height = orient[Otype,]$height
  paper_orientation = orient[Otype,]$papr

  Outfile = Set_Outfile(Scriptfile, Yr = SelectYr, Stream = SelectStream)
  cat(paste("Plot:", Scriptfile))
  source(paste(PlotDir, Scriptfile, sep = "/"), local = TRUE)

  if (dev.cur() != 1) dev.off()
}

#------------------------------------------------------------------------------
# The following function is called by a plot script to open either a jpeg or
# PDF device for output.  
#
# A call to Check_file-exists is made to delete an existing plot.  This does 
# not seem to be necessary on all platforms but is included to cover all 
# eventualities (acknowlegement: Steve Bosley, Hampshire Astronomy Group)
#------------------------------------------------------------------------------

select_dev <- function(Ofile, Otype = "JPG", wd = 1000, ht = 1000, pp = "a4") {

  # Close any open devices (other than NULL)
  repeat {
    if (dev.cur() == 1) {
      break
    }
    dev.off()
  }

  if (Otype == "JPG") {
    Check_file_exists(paste(Ofile, ".jpg", sep = ""))
    jpeg(filename = paste(Ofile, ".jpg", sep = ""),
    width = wd, height = ht,
    units = "px", res = 150, pointsize = 12, quality = 100, bg = "white")
  }
  if (Otype == "PDF") {
    Check_file_exists(paste(Ofile, ".pdf", sep = ""))
    pdf(paste(Ofile, ".pdf", sep = ""),
    onefile = TRUE, paper = as.character(pp),
    width = wd, height = ht)
  }
}
#-------------------------------------------------------------------------------
#-- Drop file if it exists. 
#-------------------------------------------------------------------------------
Check_file_exists <- function(Ofile) {
  if (file.exists(Ofile)) {
    x <- file.remove(Ofile)
    Sys.sleep(1)
    cat(" (Overwrite) \n")
  } else {
    cat(" (New) \n")
  }
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

  AStreams <- unique(mu$X_stream, incomparables = FALSE, fromLast = FALSE, nmax = NA)

  # Read stream data from config file 

  streamnames = paste(RefDir, "streamnames.csv", sep = "/")
  lookup <- read.csv(streamnames, header = TRUE)
  lookup <- subset(lookup, code == "ALL" | code %in% AStreams)
  Streamlist <- as.vector(paste(lookup[, 1], "   (", lookup[, 2], ")", sep = ""))

  # Prompt user for stream (listing only streams in the data file)

  # i <- menu(Streamlist, graphics=TRUE, title="Choose stream")
  i = 1 # force ALL
  if (i == 0) stop("No stream selected")

  # Extract stream attributes from config file

  SelectStream = as.character(lookup[i, 1])

  stream <- rbind(as.character(lookup[i, 1]), paste("(", as.character(lookup[i, 2]), ")", sep = ""), as.numeric(lookup[i, 5]), as.character(lookup[i, 6]), as.character(lookup[i, 7]))

  return(stream)
}
match_stream <- function(mu, strm) {
  streamnames = paste(RefDir, "streamnames.csv", sep = "/")
  lookup <- read.csv(streamnames, header = TRUE)
  mtch <- lookup[lookup$code == strm,]
  stream <- rbind(as.character(mtch[1, 1]), paste("(", as.character(mtch[1, 2]), ")", sep = ""), as.numeric(mtch[1, 5]), as.character(mtch[1, 6]), as.character(mtch[1, 7]))

  return(stream)
}


get_year <- function(mu) {
  #===============================================================================
  #
  #-- Presents a menu of years based on date range in data frame mu
  #
  #===============================================================================
  #-- Get year; options include only those years in the input data frame
  Years <- unique(substring(mu$X_localtime, 1, 4), incomparables = FALSE, fromLast = FALSE, nmax = NA)
  Years <- sort(Years)
  Years <- c("ALL", Years)
  # Promt user for year of year of report

  i <- menu(Years, graphics = TRUE, title = "Choose year")

  if (i == 0) stop("No year selected")

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
  filt <- matrix(c("Comma separated / Excel files", "*.csv"),
            nrow = 1, ncol = 2, byrow = TRUE,
            dimnames = list(c("csv"), c("V1", "V2")))

  if (is.na(SourceUnified)) {
    infile <- tk_choose.files(caption = "Select UFO Orbit Unified file", multi = FALSE, filters = filt)
  } else {
    SourceUnified = gsub('YEAR', SelectYr, SourceUnified)
    infile <- paste(DataDir, SourceUnified, sep = "/")
  }

  cat(paste("Ingesting UFO data file:", infile, "\n"))

  if (infile == "") stop

  # --- Read the UFO data file

  # Read raw data
  mt <- read.csv(infile, header = TRUE, stringsAsFactors = FALSE)

  # Standardise ID1
  cat("Standardising ID1\n")
  mt$X_ID1 <- ifelse(substring(mt$X_ID1, 1, 1) == "_", substring(mt$X_ID1, 2), substring(mt$X_ID1, 3))

  # standardise localtime
  mt$X_localtime <- as.POSIXct(strptime(mt$X_localtime, "_%Y%m%d_%H%M%S"))

  # remove NA localtimes if any
  mt <- subset(mt, !is.na(X_localtime))

  # Standardise streamname
  mt$X_stream <- toupper(ifelse(substring(mt$X_stream, 1, 2) == "_J", substring(mt$X_stream, 5), substring(mt$X_stream, 2)))

  cat(paste("Rows ingested:", nrow(mt), "\n"))

  return(mt)

}

read_ufa <- function(mx) {
  #===============================================================================
  #
  #-- Presents file picker filtered for CSV files (if no preconfigured input file)
  #-- Ingests file
  #-- Standardises data
  #
  #===============================================================================

  # - Read consolidatee UFO Analyser CSV files

  # setup filter
  filt <- matrix(c("Comma separated / Excel files", "*.csv"),
            nrow = 1, ncol = 2, byrow = TRUE,
            dimnames = list(c("csv"), c("V1", "V2")))

  if (is.na(SourceSingle)) {
    infile <- tk_choose.files(caption = "Select UFO Analyser Consolidated file", multi = FALSE, filters = filt)
  } else {
    SourceSingle =  gsub('YEAR', SelectYr, SourceSingle)
    infile <- paste(DataDir, SourceSingle, sep = "/")
  }

  cat(paste("Ingesting UFO data file:", infile, "\n"))

  if (infile == "") stop

  # --- Read the UFO data file

  # Read raw data
  mt <- read.csv(infile, header = TRUE, stringsAsFactors = FALSE)

  cat(paste("Raw rows ingested:", nrow(mt), "\n"))

  # remove NA localtimes if any
  mt <- subset(mt, !is.na(mt$LocalTime))

  # standardise localtime
  mt$LocalTime <- as.POSIXct(strptime(mt$LocalTime, "%Y%m%d_%H%M%S"))

  cat(paste("Rows ingested after time fixed:", nrow(mt), "\n"))

  # Standardise streamname
  mt$Group <- trimws(mt$Group, "both")
  mt$Group <- toupper(ifelse(substring(mt$Group, 1, 1) == "J", substring(mt$Group, 4), mt$Group))
  mt$Group <- toupper(ifelse(substring(mt$Group, 1, 1) == "I", substring(mt$Group, 4), mt$Group))

  mt <- subset(mt, mt$Group != 'TBC')

  cat(paste("Rows ingested:", nrow(mt), "\n"))

  return(mt)

}

filter_stream <- function(mx, mstream = "ALL", myr = "ALL", mtype = "UNIFIED", itype = "UNIFIED") {
  #===============================================================================
  #
  #-- Filters input data frame mx for all meteors meeting selection criteria
  #-- (stream and year)
  #
  #===============================================================================

  if (itype == "UNIFIED") {
    #-- Filter input data frame by type (e.g. unified), stream, and year
    cat(paste("Filtering", itype, "input for stream:", mstream, ", year:", myr, ", type:", mtype, "\n"))
    if (mtype == "UNIFIED") {
      my <- subset(mx, substring(X_ID1, 2, 8) == "UNIFIED")
      my$X_ID1[nchar(my$X_ID1) == 11] <- sub("D_", "D_0", my$X_ID1[nchar(my$X_ID1) == 11])
    }

    if (mtype != "UNIFIED") my <- subset(mx, substring(X_ID1, 2, 8) != "UNIFIED")

    if (mstream != "ALL") my <- subset(my, my$X_stream == mstream)

    if (myr != "ALL") my <- subset(my, substring(my$X_localtime, 1, 4) == myr)
  } else # SINGLE data set
  {
    #-- Filter input data frame by type (e.g. unified), stream, and year
    cat(paste("Filtering", itype, "input for stream:", mstream, ", year:", myr, ", type:", mtype, "\n"))

    if (mstream != "ALL") {
      my <- subset(mx, mx$Group == mstream)
    } else {
      my <- mx
    }
    if (myr != "ALL") my <- subset(my, substring(my$LocalTime, 1, 4) == myr)

  }
  cat(paste(mtype, "Matched rows:", nrow(my), "\n"))
  return(my)
}


get.bin.counts = function(x, name.x = "x", start.pt, end.pt, bin.width) {
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
  x = x[(x >= start.pt) & (x <= end.pt)]
  counts = hist(x, breaks = br.pts, plot = FALSE)$counts
  dfm = data.frame(br.pts[-length(br.pts)], counts)
  names(dfm) = c(name.x, "freq")
  return(dfm)
}


filter_apply_qa <- function(mx) {
  #===============================================================================
  #
  #-- Filters input data frame mx for all meteors meeting quality criteria
  #
  #===============================================================================
  #-- Filter input data frame by type (e.g. unified), stream, and year
  source(paste(root, "/CONFIG/Lib_QA.r", sep = ""))
  n_start <- nrow(mx)
  cat("\n")
  cat(paste("QA filtering:\n"))
  cat(paste("=============\n"))
  my <- subset(mx, X_dGP <= QA_dGP & X_QA >= QA_QA & abs(mx$X_dv12) <= QA_dv12 & abs(mx$X_Gm) >= QA_GM & X_dur >= QA_Dur & X_H1 <= QA_H1 & X_H2 >= QA_H2 & X_Qo >= QA_Qo & X_Qc >= QA_Qc)
  cat(paste("- dc12 <=", QA_dv12, "\n"))
  cat(paste("- dGP  <=", QA_dGP, "\n"))
  cat(paste("- GM   >=", QA_GM, "\n"))
  cat(paste("- Dur  >=", QA_Dur, "\n"))
  cat(paste("- QA   >=", QA_QA, "\n"))
  cat(paste("- Qo   >=", QA_Qo, "\n"))
  cat(paste("- Qc   >=", QA_Qc, "\n"))
  cat(paste("- H1   <=", QA_H1, "\n"))
  cat(paste("- H2   >=", QA_H2, "\n\n"))
  n_end <- nrow(my)
  pct = 0
  if (n_end != 0) { pct = (100 * n_end / n_start) }
  cat(paste("Rows out:", n_end, ", ", round(100 - pct, digits = 1), "% loss.\n"))
  return(my)
  QA_Delta_GP
}

