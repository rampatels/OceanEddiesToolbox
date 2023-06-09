function plotEndtypeTrack(tracks, filter_day, coast, xtick, ytick)
% if you want number of eddy in your particuler xtick and ytick then you
% should fileter your tracks first and then apply this function otherwise
% you may have wrong number of eddies in your region
% mention about coast arrangement i.e first column should be longitude and
% second latitude.
% input agrument
if (nargin ~= 5)
   error('plotEndtypeTrack: Must pass 5 parameters')
end
if (~iscell(tracks))
    error('plotEndtypeTrack: Tracks data must be in cell')
end
%  Filtering criterion
if (numel(filter_day) ~= 1)
    error('plotEndtypeTrack: only single filter criterion at a time')
end
% Cyclonic Eddy Trakcs
c_age = get_eddy_indices(tracks, filter_day);

% Plotting
figure(1); clf
xmin = min(xtick); xmax = max(xtick);
ymin = min(ytick); ymax = max(ytick);
% Cyclonic Eddy
for ind = 1:length(c_age)
    axis([xmin, xmax, ymin, ymax])
    var = tracks{c_age(ind)};
    lon = var(:,2);
    lat = var(:,1);
    plot(lon, lat, '-b','linewidth', 1.2)
    hold on
    plot(lon(end), lat(end),'ob','MarkerFaceColor','b','Markersize',5,'MarkerEdgecolor','k') % Birth Place : 1, dissipation: end
end
plot(coast(:,1),coast(:,2),'linewidth',2,'color','k')
% Plotting Region of Interest
line([135, 155, 155, 135, 135], [-55, -55, -45, -45, -55],'color','k','linewidth', 2)
hold off
set(gca, 'box', 'on', 'linewidth', 2, 'fontsize', 12, 'fontweigh', 'bold')
grid on
[xticklabel, yticklabel] = XYTickLabel(xtick, ytick);
set(gca, 'xtick', xtick, 'xticklabel', xticklabel, 'ytick', ytick, 'yticklabel', yticklabel)
title(['Age \geq ', num2str(filter_day), ' days: ', 'Eddies = ', num2str(length(c_age)) ])
end
% To procure Eddies indices from track data
function [eddyInd] = get_eddy_indices(track_data, filter_day)
x = 0;
for eInd = 1:length(track_data)
    var = track_data{eInd};
    [nday, npar] = size(var);
    if nday >= filter_day && npar == 5
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
    if nday >= filter_day && npar == 5
        eddyInd(x) = eInd;
        x = x +1;
    end
    clear var nday npar
end
end
% Preparing longitude and latitude Labels
function [xticklabel, yticklabel] = XYTickLabel(xtick, ytick)
ln = length(xtick); xticklabel = cell(ln,1);
parfor ix = 1:ln
    if xtick(ix) < 0
        xvalue = abs(xtick(ix));
        xticklabel{ix} = [num2str(xvalue), ' ', char(176),'W'];
    elseif xtick(ix) > 0
        xticklabel{ix} = strcat(num2str(xtick(ix)), ' ', char(176), 'E');
    else
        xticklabel{ix} = strcat(num2str(xtick(ix)), ' ', char(176))
    end 
end
lt = length(ytick); yticklabel = cell(lt,1);
parfor iy = 1:lt
    if ytick(iy) < 0
        yvalue = abs(ytick(iy));
        yticklabel{iy} = strcat(num2str(yvalue), ' ', char(176), 'S');
    elseif ytick(iy) > 0
        yticklabel{iy} = strcat(num2str(ytick(iy)), ' ', char(176),'N');
    else
        yticklabel{iy} = strcat(num2str(ytick(iy)), ' ', char(176));
    end
end
end