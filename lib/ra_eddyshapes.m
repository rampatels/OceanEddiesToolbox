function [shape, fitshape] = ra_eddyshapes(eddies, data_lon, data_lat, R)
% This function obtains the shape of an eddy based on number of pixels
% occupied by the eddy. This can be used to identify the shape of an eddy -
% circular, elliptical or non-circular, complex polynomial shape. 
% Here, I am looping over individual eddy detected in a day

% Create oceanmask and georeferenced raster as follows
%data_lon = double(ncread('/media/patelrs/RamData/AVISO/2016/dt_global_allsat_phy_l4_20160101_20170110.nc', 'longitude'));
%data_lat = double(ncread('/media/patelrs/RamData/AVISO/2016/dt_global_allsat_phy_l4_20160101_20170110.nc', 'latitude'));
%oceanmask = zeros(length(data_lat), length(data_lon));
% R geographical raster for fitshape
%geo_raster_lat_limit = double([data_lat(1), data_lat(end)]);
%geo_raster_lon_limit = double([data_lon(1), data_lon(end)]);
%
%R = georefcells(geo_raster_lat_limit, geo_raster_lon_limit, size(oceanmask));

phi = linspace(0,2*pi,50); % angle parameter to create ellipse
shape = cell(length(eddies),1);
fitshape = cell(length(eddies), 1);
%
for ieddy = 1:length(eddies)
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
end

