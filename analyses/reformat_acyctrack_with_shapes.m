function reformatted_data = reformat_acyctrack_with_shapes(eddy_dir, dates, anticyclonic_tracks, lon, lat, R)
% This function format data into chelton's data format for anticyclonic eddies
% only, with addition of shape and fitted shape variables. Thus requires
% three additional inputs, namely original longitude (lon) and latitude (lat) of the
% SLA map and geographical raster R. The raster is created as follow:
% To complement Faghmous et al. 2015 data. NOTE: this function works with
% regional data as well as without using global SLA map.. 
% data_lon = double(ncread('/media/patelrs/RamData/AVISO/2016/dt_global_allsat_phy_l4_20160101_20170110.nc', 'longitude'));
% data_lat = double(ncread('/media/patelrs/RamData/AVISO/2016/dt_global_allsat_phy_l4_20160101_20170110.nc', 'latitude'));
% geo_raster_lat_limit = double([data_lat(1), data_lat(end)]);
% geo_raster_lon_limit = double([data_lon(1), data_lon(end)]);
%
% R = georefcells(geo_raster_lat_limit, geo_raster_lon_limit, [length(data_lat), length(data_lon)]);
% NOTE: [length(data_lat), length(data_lon)] must be of the same dimension
% as initial SLA map. 

 if ~isempty(anticyclonic_tracks)
     [ acyc_amps, acyc_geospeeds, acyc_lats, acyc_lons, acyc_surface_areas, acyc_shape, acyc_fitshape ] = ...
         get_eddy_attributes(eddy_dir, 'anticyc', dates, lon, lat, R);

    acyc_eddy_counts = zeros(length(acyc_lats), 1);
    for i = 1:length(acyc_lats)
        acyc_eddy_counts(i) = length(acyc_lats{i});
    end

    acyc_eddy_track_indexes = get_eddy_track_index(acyc_eddy_counts, anticyclonic_tracks);
 end
n_edd=sum(acyc_eddy_counts);
 
[eddies_t.x,eddies_t.y,eddies_t.amp,eddies_t.area,eddies_t.u,...
eddies_t.area,eddies_t.Ls,eddies_t.id,eddies_t.cyc,eddies_t.track_day]=deal(nan(n_edd,1));
st=1;
for n=1:length(dates)
    disp(['Date: ', num2str(n)]);
    disp(['grabbing cyc eddies from ', num2str(st), ' to ', num2str(acyc_eddy_counts(n)+st-1)]);
    eddies_t.x(st:acyc_eddy_counts(n)+st-1)=acyc_lons{n};
    eddies_t.y(st:acyc_eddy_counts(n)+st-1)=acyc_lats{n};
    eddies_t.amp(st:acyc_eddy_counts(n)+st-1)=acyc_amps{n};
    eddies_t.u(st:acyc_eddy_counts(n)+st-1)=acyc_geospeeds{n};
    eddies_t.area(st:acyc_eddy_counts(n)+st-1)=acyc_surface_areas{n};
    eddies_t.Ls(st:acyc_eddy_counts(n)+st-1)=sqrt(acyc_surface_areas{n}./pi);
    eddies_t.cyc(st:acyc_eddy_counts(n)+st-1)=-1;
    eddies_t.track_day(st:acyc_eddy_counts(n)+st-1)=dates(n);
    eddies_t.id(st:acyc_eddy_counts(n)+st-1)=acyc_eddy_track_indexes{n};
    eddies_t.shape(st:acyc_eddy_counts(n)+st-1)=acyc_shape{n, 1}; %added@RP
    eddies_t.fitshape(st:acyc_eddy_counts(n)+st-1)=acyc_fitshape{n, 1}; %added@RP

    st=st+acyc_eddy_counts(n);
end
ii=find(isnan(eddies_t.id));
eddies_t.x(ii)=[];
eddies_t.y(ii)=[];
eddies_t.amp(ii)=[];
eddies_t.u(ii)=[];
eddies_t.area(ii)=[];
eddies_t.Ls(ii)=[];
eddies_t.cyc(ii)=[];
eddies_t.track_day(ii)=[];
eddies_t.id(ii)=[];
eddies_t.shape(ii)=[]; % added@RP
eddies_t.fitshape(ii)=[]; % added@RP

reformatted_data = eddies_t;
end
%% Supporting Functions
% to get eddies parameters for combining
function [ amps, geospeeds, lats, lons, surface_areas, shape, fitshape ] = get_eddy_attributes(eddy_dir, eddy_file_initial, dates, lon, lat, R)
%GET_EDDY_ATTRIBUTES Summary of this function goes here
%   Detailed explanation goes here

amps = cell(size(dates));
geospeeds = cell(size(dates));
lats = cell(size(dates));
lons = cell(size(dates));
surface_areas = cell(size(dates));
shape = cell(size(dates)); % added@RP
fitshape = cell(size(dates)); % added@RP
for i = 1:length(dates)
    disp(i)
    try
        temp = load([eddy_dir eddy_file_initial '_' num2str(dates(i)) '.mat']);
    catch
        disp(['Error loading file: ', eddy_dir, eddy_file_initial, '_', num2str(dates(i)), '.mat']);
        continue;
    end
    names = fieldnames(temp);
    if length(names) == 1
        eddies = temp.(names{1});
    end
    amps{i} = [eddies.Amplitude];
    geospeeds{i} = [eddies.MeanGeoSpeed];
    surface_areas{i} = [eddies.SurfaceArea];
    lats{i} = [eddies.Lat];
    lons{i} = [eddies.Lon];
    [pixelshape, fittedshape] = ra_get_eddy_shapes(eddies, lon, lat, R);% added@RP
    shape{i, 1} = pixelshape;
    fitshape{i, 1} = fittedshape;
end
end% endget_eddy_attributes

% This part extracts indices for each tracks.
function [ track_indexes ] = get_eddy_track_index( eddy_counts, tracks )
%GET_EDDY_TRACK_INDEX Summary of this function goes here
%   Detailed explanation goes here

track_indexes = cell(size(eddy_counts));
for i = 1:length(eddy_counts)
    track_indexes{i} = nan(eddy_counts(i), 1);
end

for i = 1:length(tracks)
    curr_track = tracks{i};
    for j = 1:size(curr_track, 1)
        curr_date_index = curr_track(j, 3);
        curr_eddy_index = curr_track(j, 4);
        track_indexes{curr_date_index}(curr_eddy_index) = i;
    end
end
end %end track_indexes

% getting eddy shape and fitted shape from eddies.Stas variable to examine
% shape of an eddy
function [shape, fitshape] = ra_get_eddy_shapes(eddies, data_lon, data_lat, R)
% This function obtains the shape of an eddy based on number of pixels
% occupied by the eddy. This can be used to identify the shape of an eddy -
% circular, elliptical or non-circular, complex polynomial shape. 
% Here, I am looping over individual eddy detected in a day

phi = linspace(0,2*pi,50); % angle parameter to create ellipse
shape = cell(length(eddies),1);
fitshape = cell(length(eddies), 1);
%
parfor ieddy = 1:length(eddies)
    oceanmask = zeros(length(data_lat), length(data_lon));
    pixellist = eddies(ieddy).Stats.PixelIdxList;
    oceanmask(pixellist) = 1;
    [x_loc, y_loc] = find(oceanmask==1);
    boundary = bwtraceboundary(oceanmask, [x_loc(1), y_loc(1)], 'N'); % tracing the next value in closewise direction
    % Convert boundary to geolocation
    shape{ieddy} = [data_lon(boundary(:, 2)), data_lat(boundary(:, 1))]; % the pixelled shape
    % fitting an ellipse to pixelled shape
    a = eddies(ieddy).Stats.MajorAxisLength/2; % major axis
    b = eddies(ieddy).Stats.MinorAxisLength/2; % minor axis
    theta = atan(-eddies(ieddy).Stats.Orientation*(pi/180)); % rotated to fix an issue, orientation
    % ellipse contour
    x_fit = a*cos(theta)*cos(phi) - b*sin(theta)*sin(phi);
    y_fit = a*sin(theta)*cos(phi) + b*cos(theta)*sin(phi);
    % putting around the center of an ellipse
    obj = regionprops(oceanmask, 'Centroid'); % since its not recorded in original data
    x_fit = x_fit + obj.Centroid(1); 
    y_fit = y_fit + obj.Centroid(2);
    %
    [lat_fit, lon_fit] = intrinsicToGeographic(R, x_fit, y_fit);
    fitshape{ieddy} = [lon_fit', lat_fit']; % the fitted ellipse
    % Check 
% figure(1);clf
% plot(eddies(1).Lon, eddies(1).Lat, '*r')
% hold on
% plot(shape{1}(:,1), shape{1}(:,2), '-r')
% plot(fitshape{1}(:,1), fitshape{1}(:,2), '--r')
% hold off
end % endfor
end% end ra_get_eddy_shapes

