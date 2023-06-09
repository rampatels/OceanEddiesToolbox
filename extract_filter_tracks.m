function filter_tracks = extract_filter_tracks(track_indices, track_data)
% this function extracts filtered data from original tracks

str = 'extract_filter_tracks.m: ';
if (nargin ~= 2)
    error([str, 'requires only two input arguments'])
end
indices = length(track_indices);
if (numel(track_indices) ~= indices)
    error([str, 'track_indices must be Vector'])
end
if ~iscell(track_data)
    error([str, 'track_data must be in Cell'])
end

filter_tracks = cell(1,indices);
for ind = 1:indices
    disp(['Iteration : ', int2str(ind)])
    filter_tracks{ind} = track_data{track_indices(ind)};
end
end