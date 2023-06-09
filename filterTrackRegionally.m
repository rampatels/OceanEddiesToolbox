function newTracks = filterTrackRegionally(lonlimit, latlimit, tracks)
% This function identifies eddies that are born and died in the region of
% interest
%

% Longitude and latitude limits check
if numel(lonlimit) ~= 2 || numel(latlimit) ~= 2
    error('Only one range of longitude and latitude is accepted')
end
if ~(min(lonlimit) >= 0 && max(lonlimit) <= 360)
    error('longitude limit must be positive and between 0 to 360')
end
if ~(min(abs(latlimit)) >= 0 && max(abs(latlimit)) <= 180)
    error('latitude limit must be between 0 to 180')
end
% 
nfile = length(tracks);
parfor fInd = 1:nfile
    lon = tracks{fInd}(:,2);
    lat = tracks{fInd}(:,1); 
    if (lon >= min(lonlimit) & lon <= max(lonlimit) & lat >= min(latlimit) & lat <= max(latlimit)) %#ok
        disp(fInd);
        indices(fInd) = fInd;
    else
        continue
    end
end
notreq = indices == 0;
indices(notreq) = [];
newTracks = extract_filter_tracks(indices, tracks);