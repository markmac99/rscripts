#=============================================================================
#
#-- Author: P Campbell-Burns, UKMON
#
#
#-- Description:
#
#   This script defines the orbital element reference data for known streams.
#
#   Function get_elements() returns the elements for the seeted stream in the form
#   of a data frame with properly defined column names.
#
#-- Version History
# 
#   Vers  Date          Notes
#   ----  ----          -----
#   1.0   03/12/2015    First release
#
#=============================================================================



# Define orbit reference data

#Stream  <-            Name         peri      node     incl     eccent    q         D_threshold             
#----------------------------------------------------------------------------------------------
Perseids <- data.frame(stream_name="Perseids",  p=150.4,    n=137.9,   i=113.22, e=0.96,  q=0.949,    d_threshold=0.7) 
Geminids <- data.frame(stream_name="Geminids",  p=324.5125, n=265.267, i=22.24,  e=0.889, q=0.139825, d_threshold=0.7)

# Routine to return properly labelled stream data
get_elements <- function(stream) {
  return(stream)
}

# Define full stream list
stream_list = rbind(Perseids, Geminids)
