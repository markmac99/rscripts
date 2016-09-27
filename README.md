# R suite for the analysis of UFO Orbit data

Peter Campbell-Burns, Richard Kacerek
UK Meteor Observation Network
ukmeteornetwork@gmail.com

These scripts provide a basic set of reports in tabular and graphical format and include examples of D_Criterion analysis  and interactive 3D plots of meteor orbits.    Users are invited to use and adapt these scripts to meet their own needs.  

We hope too that others will be willing to contribute ideas and analytical methods (and scripts) so that we can add to this suite and build a more complete set of resources for the meteor community.

## License

This work is shared under the Creative Common  Non Commercial Sharealike License V4.0 (www.creativecommons.org/licebses/by-nc-sa/4.0/)

## Installing

1.	Install R and RStudio (if not already installed).
2.	Unzip the ANALYSIS folder into the My Documents folder (Windows).

## Using the analysis package

1. Save UFO Orbit csv file to the ANALYSIS/DATA folder (anyother folder can be used)
2. In the RStudio or R Console, open and run the master script: ANALYSIS/GENERATE_REPORTS.R
3. In response to the prompts:
  - Select the UFO Orbit csv input file (this must be a UFO ORBIT csv file), 
  - Select a stream name (or ALL) from the displayed list,
  - Select a year (or ALL) from the displayed list.
4. Make a mental note to buy the guys from UKMON a beer at the next IMO conference.

Reports are generated automatically and will be written to the ANALYSIS/REPORTS folder.

Note: the UFO ORBIT csv export must contain Unified observations; corresponding paired station observations need not be exported.

Reference Data File ANALYSIS/CONFIG/streamenames.csv contains stream names and stream activity information used by 
various graphical reports, solar longitude date ranges are used for timeline plots where activity is displayed by solar longitude.  

|Column|Description|
|------|-----------|
|code|3 character stream mnemonic (e.g. AAHù)|
|streamname|Full stream name (e.g. August alpha |Herculids)|
|sol_1|Solar longitude of stream start|
|sol2|Solar longitude of stream end|
|sol_peak|Solar longitude of stream peak|
|selectstart|Date and time of stream start|
|selectend|Date and time of stream end|

SelectStart and SelectEnd are used by timeline plots where the time interval is displayed in a date format (solar 
longitude is not well understood by the general public making a date time format is more useful for plots generated for PR / Outreach).

## About the distribution

The distribution comprises a set of R scripts and a reference data file organised in folders as follows.

|Folder|Description|
|------|-----------|
|ANALYSIS|Top level directory|
|ANALYSIS/DATA|Input data directory (use is optional)|	
|ANALYSIS/LIBRARY/PLOTS|Scripts creating graphical output|
|ANALYSIS/LIBRARY/TABLES|Scripts creating tabular output|
|ANALYSIS/LIBRARY/FUNCTIONS|Common functions called by scripts|
|ANALYSIS/CONFIG|Config script and reference data|
|ANALYSIS/REPORTS|Folder to receive report outputs|
|ANALYSIS/RWORKSPACE|R workspace (saved sessions)|

### Main Report Modules

|File|Description|
|----|-----------|
|GENERATE_REPORTS.R|Full reporting package, importing data applying quality criteria and generating tables and plots|
|STREAM_ANALYSIS_ORBITS.R|Imports data, performs D criterion analysis against a selected reference orbit and generates an interactive 3d plot of Orbits meeting threshold criterion.|
|STREAM_ANALYSIS_CLASSIFY.R|Imports data, finds best match for each observation against a list of reference orbits and plots D_Criteria by stream|

### Report Libraries

|File|Description|
|----|-----------|
|Common_Functions|Common reoutines used for data gestion, filtering, quality criteria and report formatting|
|D_Criteia|Script to calculate D_Criteria against a reference orbit (Dsh, DD and DH)|
|Orbit_3D|generic routines to produce orbital plots in an (interactive) 3D projection.|
|Orbital_Elements|Establishes a set of data frames holding reference orbits|

### Report Sub-modules

#### Plots

|Analysis Type|Summary|R file|
|--------------------|--------------|--------|
|Simple counts|Counts by stream (ten highest counts)|streamcounts.r|
||Meteor counts by solar longitude|counts_by_sol.r|
||Number of matched observation (UNIFIED_2, UNIFIED_3, etc)|stream_plot_by_correlation.r|
|Stream analysis|Number of meteors by solar longitude (sol) over stream duration|stream_plot_timeline_solar.r|
||Scatter-plot showing radiant (Right ascension v Declination) for individual meteors|stream_plot_radiant.r|
||Multi-chart plot showing movement of radiant (2SD and 3D plots)|stream_plot_radiant_movement.r|
||Table of matched observations (counts by stream and by year)|stream_counts_by_year.r||Magnitude|Frequency distribution of absolute magnitudes (amag)|stream_plot_mag.r|
||Scatter plot of absolute magnitude (amag) against start height (H1) and amag against end height (H2) for individual meteors.  |abs_magnitude_vs_h1_h2.r|
||Scatter plot of absolute magnitude (amag) against start height (H1) and amag against end height (H2) for individual meteors with a least squares line fit.|abs_magnitude_vs_h1_h2_reg.r|
||Scatter plot of absolute magnitude (amag) against height difference (H1 ñ H2) for individual meteors with a least squares line fit.|abs_magnitude_vs_h_diff_reg.r|
||Count of stream meteors with magnitudes less than or equal to -4 (all streams)|fireball_by_month.r|
||Count of meteors with magnitudes less than or equal to -4 (by stream)|fireball_by_stream.r|
|Velocity|Frequency distribution of Observed velocities (vo)|stream_plot_vel.r|
||Frequency distribution of Helio-centric Velocity (vs)|heliocentric_velocity.r|
|Orbital|Scatter plot of semi-major axis (a) vs ascending node (node)|semimajor_v_ascending.r|
||Scatter plot of semi-major axis (a) vs inclination (incl)|semimajor_v_inclination.r|
||Frequency distribution of Semi-major axis (a)|semimajoraxisfreq.r|
||Frequency distribution of semi-major axis (A) with a range of bin sizes.|a_binned_multi.r|
||Frequency distribution of semi-major axis (A) with a fixed (configurable) bin size.|a_binned.r|
|Ablation|Line plot of start height (H1) to end height (H2) for individual meteors.  This plot provides a simple visualisation of where in the atmosphere ablation is taking place.|stream_ablation.r|
|Quality|Plot of difference in Vo between station and unified data (all stations)|delta_v0 _overall.r|
||Plot of difference in Vo between station and unified data by station|delta_v0_by_station.r|
||Distribution of quality metric QA (all stations)|qa_overall.r|
||Distribution of quality metric QA by station|qa_by_station.r|
||Summary of Delta Vo by station (min, max, mean, sd)|delta_vo_by_station.r|

#### Tables

|Analysis Type|Summary|R file|
|--------------------|--------------|--------|
|Simple counts|List of meteors brighter than amag < -4|fireball_detect.r|
||Table of matched observations (count of Station A / Station B pairs)|station_match_tab_correlation.r|
||Number of matched meteor observations by stream|stream_counts.r|
||Number of matched meteor observations by station|streamcounts_plot_by_station.r|
||Number of matched meteor observations by station|stream_counts_by_year.r|


## Customisation

Configuration settings are in file ANALYSIS/CONFIG/Lib_config.r:

|Parameter|Description|
|---------|-----------|
|SourceUnified|Input file (If NA, the master script prompts)| 
|OutType|Output type: PDF, JPEGùor NA (prompt at run time)|
|Landscape, Portrait|Page Sizes for portrait and landscape output|
|SelectInterval, SelectIntervalSol|Intervals (bin sizes) for timeline plots|

File path variables:	

|Variable|Filepath value|
|--------|-----|
|Root|Root folder (Analysis)|
|ReportDir|Reports output folder|
|WorkingDir|R working directory|
|TabsDir|Scripts for generating tabular output|
|PlotDir|Scripts for generating graphical output|
|FuncDir|Common functions|
|DataDir|Input data directory|
|RefDir|Reference data|

## Report sub-module interfaces

Analysis scripts are called using the R source statements.   Each script can use the following in-scope data objects created by the master script: 

|Object|Description|
|------|-----------|
|mt|Data frame containing imported UNIFIED UFO |Orbit data
|mu|Cleaned and filtered (by stream / year) mt |rows for unified observations
|ms|Cleaned and filtered (by |stream / year) mt |rows for paired station observations|
|Dataset|Descriptive title printed on the plot footer|
|SelectStream|The 3 digit mnemonic for the selected stream|
|Streamname|The common name of the selected stream|
|SelectStart|The start time for timeline plots|
|SelectEnd|The start time for timeline plots|
|Solpeak|Solar longitude of a shower peak|

