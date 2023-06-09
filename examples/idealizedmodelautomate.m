% This script detects and tracks eddies for idealised Model output

% CONTENTS:
% 1: Read .nc files
% 2: Write data in format of 3D2daily function
% 3: Preprocess data
% 4: Detection and Tracking
% 5: Visualize eddies through animation

%% 1: Read .nc files
clear; clc
[var, ~, ~] = nc2mat('~/Desktop/Satellite_data/msla_yr47all_Eddy.nc');

%% 2: Write data in format of 3D2daily function
% variable
sla = var.sla; % lon lat time
% sla should be in time x lat x lon format
sla = permute(sla, [3, 2, 1]);

% time variable in Juilan format
% Since model has every 2 days data
% I created fictitious time vector based on simulation time step 
time = datenum(2016, 01, 01):datenum(2016, 12, 31);
time = time(1:2:end-2)';
 
% Similarly as per the model domain 
% longitude range 
lon = linspace(130, 150, 398)';
% latitude range
lat = linspace(-70, -40, 200)';

% data integrity check
figure(1);clf
contourf(lon, lat, squeeze(sla(1,:,:)))
figure(2);clf
contourf(squeeze(sla(1, :, :)))

% saving data to interpret the results
save idealizedModel time lon lat sla
movefile('idealizedModel.mat','~/Desktop/model_data/')

%% 3: Preprocess data
clc; clear
% =====Input arguments =====%
path_n_filename = '~/Desktop/model_data/idealizedModel.mat';

ssh_save_path = '~/Desktop/Satellite_data/ModelRun/';
%=======
% Preprocessing data for complete run
set_up_data_3D2daily(path_n_filename, ssh_save_path)

%% 4: Detection and tracking 
clear;
% =====Input arguments for complete_run=====%
% My SLA data archived in \textbf{Myssh} directory 
ssh_path = '~/Desktop/Satellite_data/ModelRun/';

% Note: following directories will be generated by the script if did not exist at the location. 
% Furthermore, it will also generate directories for modified eddies and track if you 
% had allowed eddy to unassociate. i.e 'yes' at fake eddy argument. 
eddies_save_path = '~/Documents/MATLAB/OceanEddies-master/MyRuns/Eddy'; 
tracks_save_path = '~/Documents/MATLAB/OceanEddies-master/MyRuns/Tracks';
viewer_data_save_path = '~/Documents/MATLAB/OceanEddies-master/MyRuns/Modified/';

% These are extra outputs more detail please follow up text in section 3
viewer_path = '~/Documents/MATLAB/OceanEddies-master/MyRuns/Extra_viewer/';
%========
% running software 
% NOTE: I turned on padding option and detecting and tracking eddies with minimum of 16 pixel size.
complete_run(ssh_path, eddies_save_path, tracks_save_path, 'yes', viewer_data_save_path, viewer_path)

%% 5: Prepare movie
% Loading Sea Surface Height data
clear; clc;

old_path = pwd;
ssh_path = '~/Desktop/Satellite_data/ModelRun/';
cd(ssh_path)
%
filenames = dir('ssh_*.mat');
nfiles = length(filenames);
%
load lon.mat
load lat.mat
load dates.mat
%
cd(old_path)
% 2) Loading Eddies location
eddy_path = '~/Documents/MATLAB/OceanEddies-master/MyRuns/Eddy/';
eddyfiles = dir([eddy_path, 'cyc*.mat']); %==== Change here and re-run the script

% 3) Preparing movie
close all
h = figure(11);
set(h, 'Position', [100 678 560 420])
% ==Prepare Video file==
vidObj = VideoWriter('CycEddies.avi'); %==== Change file name if you re-run the script
fps = 7;
vidObj.FrameRate = fps;
vidObj.Quality = 100;
open(vidObj)
%
for fInd = 1:nfiles
    disp(['Current File: ', int2str(fInd)])
    %
    load([ssh_path, filenames(fInd).name]) % SLA data
    load([eddy_path, eddyfiles(fInd).name]) % eddy locations
    time = num2str(dates(fInd));
    time = datestr(datenum(time,'yyyymmdd'));
    % 
    elon = [eddies.Lon]; elat = [eddies.Lat];
    eamp = [eddies.Amplitude];
    cons = eamp >= 5; cons1 = eamp >= 10;
    % ensuring dates are same
    vals = regexp(filenames(fInd).name, '[0-9]');
    datessh = filenames(fInd).name(vals);
    vals = regexp(eddyfiles(fInd).name, '[0-9]');
    dateeddy = eddyfiles(fInd).name(vals);
    if dateeddy ~= datessh
        error('mismatch in dates')
    end
    % Plotting
    % Background MSLA 
    pcolor(lon, lat, data); shading interp 
    caxis([-0.5, 0.5])
    colormap(redblue(length(-0.5:0.02:0.5) - 1))
    h1 = colorbar; ylabel(h1, 'MSLA')
    hold on
    [c, ha ] = contour(lon, lat, data, [0, 0],'linest', '-', 'color', 'k', 'linewidth', 1.5);
    clabel(c, ha)
    % Plotting eddies
    plot(elon(cons), elat(cons), '.k', 'MarkerSize', 20)
    plot(elon(cons1), elat(cons1), '*k', 'MarkerSize', 20)
    % Ensuring closed contours
    contour(lon, lat, data, [-0.1, -0.1], '-', 'linewidth', 1, 'color', 'b');
    contour(lon, lat, data, [0.1, 0.1], '-', 'linewidth', 1, 'color', 'r');
    % ======
    s1 = sprintf('Day %d Date: %s , * - >10cm; . - > 5cm', fInd, time);
    title(s1, 'fontsize', 14, 'fontweigh', 'bold')
    M(fInd) = getframe(h); %#ok 
    clf
    clear data dateeddy datessh s1
end
writeVideo(vidObj, M)
close(vidObj)
