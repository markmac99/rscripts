# =================================================================
#
#-- Quality Critria
#
#-- Author: Peter Campbell-Burns, UKMON
#-- Version 1.0, 05/09/2016
#
#   These criteria are applied ONLY if Apply_QA i set to TRUE
#   in the CONFIG\Lib_Config.r file
#
#-- Shared under the Creative Common  Non Commercial Sharealike 
#   License V4.0 (www.creativecommons.org/licebses/by-nc-sa/4.0/)
#
# =================================================================

QA_QA       <- 0.15     # Total Quality Assessment
QA_dv12     <- 7.0      # Velocity difference (percent)
QA_GM       <- -100    # Min overlap of observed trajectories (%)
QA_Dur      <- 0.1      # Duration (seconds)
QA_Qo       <- 1.0      # Observed trajectory angle (degrees)
QA_Qc       <- 10.0     # Cross angle of observed plane (degrees)
QA_dGP      <- 0.5      # Difference in ground trajectory (degrees)
QA_H1       <- 200      # Start altitude (km)
QA_H2       <- 15       # End altitude (km)