function newTracks = remunwanteddate(tracks, dateind)
% This function filters eddies based on a date index
% INPUT: tracks - eddies track; dateind - date index corresponding to the
% original date vector.

% Longitude and latitude limits check
if numel(dateind) ~= 1
    error('Only one date cut off is accepted')
end

% 
nfile = length(tracks);
parfor fInd = 1:nfile
    date = tracks{fInd}(:, 3); % date 
    rmdate = find(date > dateind); %#ok
    if isempty(rmdate)
        disp(fInd);
        indices(fInd) = fInd;
    else
        continue
    end
end
notreq = indices == 0;
indices(notreq) = [];
newTracks = extract_filter_tracks(indices, tracks);