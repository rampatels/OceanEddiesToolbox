function [count, dellat, dellon] = ra_eddypropdis(n_eddies, eddy_id, eddy_x, eddy_y, color)
% This function plots pathways that eddies assumes from their origin while
% centered at their formation location. 
% NOTE: puredir - eddy movement from the center 
% puredir = 'east' or 'west', 'north', 'south'
% Output - count gives number of eddies that assumed pure direction of your
% choice

count = 0; 
for ind = 1:length(n_eddies)
    %
    eddy = eddy_id == n_eddies(ind);
    %
    xlon = eddy_x(eddy); ylat = eddy_y(eddy);
    % computing displacement from the center
    dlon = cat(1, 0, cumsum(diff(xlon)));
    dlat = cat(1, 0, cumsum(diff(ylat)));
    % recording the dispacements
    dellat{ind, :} = dlat; %#ok
    dellon{ind, :} = dlon; %#ok
    %
    % Counting number of eddies 
    count = count + 1;
    % plotting to check the data..
    plot(dlon, dlat, color, 'linewi', 1.2); hold on
    clear dlat dlon xlon ylat eddy
end