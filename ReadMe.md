# Complementary toolbox for OceanEddies software (Faghmous et al. 2015)
*This ReadMe.md belongs to **OceanEddiesToolbox** directory*

## Author
Ramkrushnbhai S. Patel $^{1,2}$

1: [Institute for Marine and Antarctic Studies](https://www.imas.utas.edu.au), [University of Tasmania](https://www.utas.edu.au), Hobart, Tasmania, Australia

2: [Australian Research Council Centre of Excellence for Climate Extremes](https://climateextremes.org.au), University of Tasmania, Hobart, Tasmania, Australia

## ABOUT
The *OceanEddiesToolbox* repository provides complementry scripts and functions to the [Faghmous et al. 2015 eddy tracking software](https://github.com/rampatels/OceanEddies). All the scripts and functions were developed during my [PhD Thesis](https://doi.org/10.25959/100.00038437) work. The thesis Appendix E contains a tutorial for interested readers.

This toolbox will be beneficial for researcher seeking to promplty generate an eddy census for a specific study region. I have commented as much as I can to guide the students.

You can cite this toolbox: 10.5281/zenodo.8025841

## CONTENTS
Directory | Description
--------- | ----------
examples | Collection of example scripts to automate the software
preprocess | preprocessing functions to detect and track eddies using complete_run.m
analyses | postprocessing and analysing functions
lib | commonly used functions 
txt file | global coastline data
ReadMe | -

### Example scripts
*AutomateEntireSoft.m* : demonstrates how to automate the software from altimetry data\
*idealizedmodelautomate.m* : demonstrates how to automate the software from idealised model output data\
*EddyAnimation.m* : makes movie to identify specific types of eddies

### Preprocessing functions
*set_up_NRTdata_regional.m* : prepares near-real-time daily SLA maps for the software\
*set_up_DTdata_regional.m* : prepares delay-mode daily SLA maps for the software with modified area-map algorithm\
*set_up_data_3D2daily.m* : converts 3D.mat file to daily to conform complete_run.m function input\
*set_up_data_3D2dailyModel.m* : flexible compare to 3D2daily function

### Postprocessing functions
*EddiesBornInROI.m* : identifies the eddies born in the region of interest from tracks data\
*filterTrackRegionally.m* : identifies eddies that are strictly in the bounded region\
*filterTrackLifespan.m* : filter eddies track by lifespan criteria\
*reformat_(a)cyctrack_with_shapes.m* : creates data table with eddy shapes using original longitude and latitude of the SLA map\
*reformat_(a)cyctrack.m* : creates data table without eddy shapes\
*remunwanteddate.m* : filters eddy from a given date\
*ra_eddiesGenDis.m* : get eddies formation or dissipation location\
*ra_lonlateddydata.m* : extract eddy positions and corresponding date\
*ra_eddiesDensity.m* : count number of eddies in a give grid box\
*ra_projparalifetime.m* : brings all the surface characteristics to uniform lifetime grid\
*ra_filtereddies_t.m* : filter structured eddy data by lifespan criteria\
*ra_eddystat.m* : prepares descriptive statistics for eddies characteristics\
*ra_filteroutliers.m* : removes outliers from a series\
*ra_eddytravel.m* : computes total travel distance by an eddy\
*ra_eddypropdir.m* : counts and plots pathways of eddies centering all eddies to origin\
*ra_eddypropdis.m* : counts and computes travel distance in degrees 
*ra_eddypropdualdir.m* : similar to ra_eddypropdir.m but for a quadrant.

### Supporting functions
*plotTrack.m* : visualise eddies track redily after the detection for the quick summary\
*extract_filter_tracks.m* : filters eddies' track\
*plot1typeTrack.m* : visualise eddies origin with the track\
*plotEndtypeTrack.m* : visualise eddies dissipation with the track\
*ra_geteddyindices.m* : get eddy indices for the eddies that are lived longer than a given number of days\
*ra_get_eddyshapes.m* : for an eddy realisation, get fitted and original shape of the eddy in longitude and latitude format\
*ra_eddyshapes.m* : supersedes ra_get_eddyshapes.m

### Filter Faghmous et al. 2015 data
*world2regional\*.m* : subset eddies data for a given region

### Contact
Comments, questions, and feeback are welcome. Questions can be submitted via e-mail to [Ramkrushnbhai Patel](Ramkrushnbhai.Patel@utas.edu.au).

### Acknowledgement
I acknowledge the developer of OceanEddies Toolbox for providing a well documented eddy tracking software. I learned a lot from the original code and tried my best to code in the similar style as the original software.