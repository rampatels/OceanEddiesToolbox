function filteredtracks = filterTrackLifespan(track_data, filter_day) 
% This function filters eddies after the detection and tracking by day
% criteria based on eddies' trajectory.

% get eddy indices that are greater than the filter_day
eddyInd = ra_geteddyindices(track_data, filter_day);
% get only tracks that satisfies the criteria
filteredtracks = extract_filter_tracks(eddyInd, track_data);

function [eddyInd] = ra_geteddyindices(track_data, filter_day)
% gets indices of eddies that lived longer than filter_day
x = 0;
for eInd = 1:length(track_data)
    var = track_data{eInd};
    [nday, npar] = size(var);
    if nday > filter_day && npar == 5
        x = x +1;
    end
    clear var nday npar
end
eddyInd = NaN(x,1);
%
x = 1;
for eInd = 1:length(track_data)
    var = track_data{eInd};
    [nday, npar] = size(var);
    if nday > filter_day && npar == 5
        eddyInd(x) = eInd;
        x = x +1;
    end
    clear var nday npar
end%end ra_geteddyindices.m