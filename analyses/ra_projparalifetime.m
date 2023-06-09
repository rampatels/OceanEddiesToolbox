function eddies_tnorm = ra_projparalifetime(eddies_t)
% This function projects the different eddy characteristics on a lifetime
% scale. 
% INPUT: eddies_t = a structure comprising eddies characteristics

% Reading data from the structure
amp = eddies_t.amp; 
Ls = eddies_t.Ls; Ls = 2*Ls;
u = eddies_t.u;
days = eddies_t.track_day;

% Statistically identifying eddies phase
numEddies = unique(eddies_t.id);
% Creating projection lifetime for consistency
nlifetime = 1:100; % uniform lifetime [%]
%
for ii = 1:length(numEddies)
    disp(['eddies Number = ', num2str(numEddies(ii))])
    idex = eddies_t.id == numEddies(ii); % identifying the eddy
    aamp = amp(idex); % amax = max(aamp); % obtaining amplitude
    als = Ls(idex); % lmax = max(als); % obtaining diameter
    d = days(idex); nlife = 1:length(d);
    au = u(idex);
    %
    ndays = (nlife./nlife(end))*100; % days in %
% interpolating to uniform %
    intamp = interp1(ndays, aamp, nlifetime, 'linear', 'extrap');
    intls = interp1(ndays, als, nlifetime, 'linear', 'extrap');
    intu = interp1(ndays, au, nlifetime, 'linear', 'extrap');
    n_amp(ii, :) = intamp; n_ls(ii, :) = intls; n_u(ii, :) = intu; %#ok
    clear idex aamp als d nlife ndays intamp intls intu
end
clear ii
% Saving data into structure
% eddies_tnorm = struct('amp' ,{}, 'dia', {}, 'speed', {}, 'lifetime', {});
% 
% 
eddies_tnorm.amp = n_amp;
eddies_tnorm.dia = n_ls;
eddies_tnorm.speed = n_u;
eddies_tnorm.lifetime = nlifetime;
