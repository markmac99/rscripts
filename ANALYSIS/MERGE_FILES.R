# ==================================================================================================
# This program will read a directory tree, import any UFO Orbit CSV files that match regular 
# expression regex and will export a sigle file with a sngle header.  Any rows inadvertently 
# converted to factors as a result of text in a numeric column are converted back to numeric
# and the offending rows dropped.  
#
#--- Author: Peter Campbell-Burns
# 
#--- Date:   27 Movember 2016 
# ==================================================================================================

root     = "~/ANALYSIS"					                # Filesystem root (~ is users documents folder on Windows)
DataDir  = paste(root,"/DATA",sep="")           # Source meteor data
outfile  = "merged_ufo_csv.csv"                 # UFO data output file
regex    =  "\\w*(_uni)\\w*(\\.csv|\\.CSV)$"    # Regular expression to match UFO files of interest

dropped = 0

# Get list of files
AA_FILES <-data.frame(list.files(path = paste(DataDir), pattern = regex, all.files = FALSE,
           full.names = TRUE, recursive = TRUE,
           ignore.case = TRUE, include.dirs = TRUE, no.. = FALSE))

# Ingest and merge each file
for (i in 1:nrow(AA_FILES)) {
  
  # Read name of first CSV
  infile <- as.character(AA_FILES[i,])
  
  # Ingest CSV
  cat(paste("Ingesting file:",infile,":"))
  temp <- read.csv(infile, header=TRUE)
  in_rows = nrow(temp)
  cat(paste(in_rows," rows. \n"))
  
  # Datacleanse any colums ingested with character values where numeric expected
  # Rows with NA values are then deleted 
  for (j in 1:ncol(temp)) {
    colnm <- colnames(temp)[j]
    if ( !(colnm == "X_stream" | colnm == "X_localtime" | colnm == "X_ID1" | colnm == "X_ID2") & is.factor(temp[,j]) ) {
      cat(paste("Note: Problem detected in input data: ",colnm,"converted from factor to numeric \n"))
      temp[,j] <- as.numeric(as.character(temp[,j]))
      temp <- temp[!is.na(temp[,j]),]
    }  
  }
  
  dropped = dropped + in_rows - nrow(temp)
  
  # If first file, use this file as the template into which other files are merged
  if (i == 1) {
       tgt <- temp
       ncol_test = ncol(tgt)
       ifile = 1
        } else if (ncol(temp) == ncol_test) {
        tgt <- rbind(tgt,temp)
        ifile = ifile + 1
        } else {
          cat(paste("WARNING: Infile format missmatch: ",infile,"skipped \n"))
        }
}

# Output CSV
write.csv(tgt, file = paste(DataDir,"/",outfile,sep=""))
cat(paste(ifile,"of",nrow(AA_FILES)," files ingested \n", 
          nrow(tgt), " rows written to",outfile,"\n",
          dropped, " rows dropped", sep=""))

rm(tgt)
rm (temp)


