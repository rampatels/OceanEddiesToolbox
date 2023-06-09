function [eddyInd] = ra_geteddyindices(track_data, filter_day)
% track_data = eddies_born; % 'cyclonic_tracks' ===Change here for Anticyclonic
% filter_day = 30; % Change for the lifespan criterion

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
end
clear track_data filter_day x npar nday eInd