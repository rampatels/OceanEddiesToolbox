function [filter_eddies_t] = ra_filtereddies_t(eddies_t, filter_day)
% This function is designed to filter eddies based on lifespan criterion
% NOTE: Designed for Chelton formatted data complimentary to Faghmous
% algorithm.
% INPUT:
% eddies_t - Chelton formatted structure output of Faghmous software
% filter_day - lifespan criterion to filter eddies
% OUTPUT: 
% filter_eddies_t - filtered eddies with new eddies index
% NOTE: doesn't support the shape at this stage.

% Ensure inputs
if nargin ~= 2
    error('ra_filtereddies_t.m: must be two inputs')
end
if ~isstruct(eddies_t)
    error('ra_filtereddies_t.m: EDDIES_T must be structure')
end
if ~isscalar(filter_day)
    error('ra_filtereddies_t.m: TRACK_DAY must be scalar')
end
% Getting Variable names
names = fieldnames(eddies_t);
% list of names
% 1: x, longitude; 2: y, latitude ; 3: amp, amplitude/strength
% 4: area, surface area; 5: u, rotational speed; 6: Ls, radius
% 7: id, eddy Id; 8: cyc, polarity; 9: track_day, 

% Reading all parameter
lon = eddies_t.(names{1}); lat = eddies_t.(names{2});
amplitude = eddies_t.(names{3}); area = eddies_t.(names{4});
rotsp = eddies_t.(names{5}); radii = eddies_t.(names{6});
eid = eddies_t.(names{7}); polarity = eddies_t.(names{8});
trackday = eddies_t.(names{9});

% Remove index preparation
neddies = unique(eid); % number of eddies
occ = accumarray(eid, 1); % counting lifespan
noneddies = occ < filter_day; % identify idex of eddies, remove
remid = neddies(noneddies); % eddies index that will be filtered

% remove small eddies
remeddies = [];
for ind = 1:length(remid)
    dummy = find(eid == remid(ind));
    remeddies = cat(1, remeddies, dummy);
end
% check
if sum(occ(noneddies)) == length(remeddies)
    disp('sum is same as remove indices')
else
    error('ra_filtereddies_t.m: sum and remove indices different')
end

% Filter variables
lon(remeddies) = []; lat(remeddies) = [];
amplitude(remeddies) = []; area(remeddies) = []; 
radii(remeddies) = []; rotsp(remeddies) = []; 
eid(remeddies) = []; polarity(remeddies) = []; 
trackday(remeddies) = [];

% % creating struct
% filter_eddies_t = struct('x', {}, 'y', {}, 'amp', {}, 'area', {}, ...
%      'u', {}, 'Ls', {}, 'id', {}, 'cyc', {}, 'track_day', {});

[~, ~, n_eid] = unique(eid);

% writing output struct
filter_eddies_t.x = lon;
filter_eddies_t.y = lat;
filter_eddies_t.amp = amplitude;
filter_eddies_t.area = area;
filter_eddies_t.u = rotsp;
filter_eddies_t.Ls = radii;
filter_eddies_t.id = n_eid;
filter_eddies_t.cyc = polarity;
filter_eddies_t.track_day = trackday;


