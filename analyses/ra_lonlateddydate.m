function [lon, lat, eddiesDate] = ra_lonlateddydate(tracks)
% This function extracts latitude, longitude and eddy date
% NOTE: use this function after using ra_eddiesGenDis.m

for fInd = 1:length(tracks)
    lat(fInd) = tracks{fInd}(1, 1);%#ok
    lon(fInd) = tracks{fInd}(1, 2);%#ok
    eddiesDate(fInd) = tracks{fInd}(1, 3);%#ok 
end