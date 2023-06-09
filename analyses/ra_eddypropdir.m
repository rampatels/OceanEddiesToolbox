function count = ra_eddypropdir(n_eddies, eddy_id, eddy_x, eddy_y, puredir, color)
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

    switch puredir
    case 'south'
            if all(dlat <= 0)
                count = count + 1;   
                plot(dlon, dlat, color, 'linewi', 1.2); hold on
%                 ylim([-3.5, 3.5])
%                 text(dlon(end), dlat(end), num2str(neddies(ind)), 'color', 'b')
            end
    case 'north'
            if all(dlat >= 0)
                count = count + 1;   
                plot(dlon, dlat, color, 'linewi', 1.2); hold on
%                 ylim([-3.5, 3.5])
%                 text(dlon(end), dlat(end), num2str(neddies(ind)), 'color', 'b')
            end
    case 'northandsouth'
            if ~all(dlat <= 0) & ~all(dlat>=0)
                count = count + 1;   
                plot(dlon, dlat, color, 'linewi', 1.2); hold on
            end
    case 'east'
            if all(dlon >= 0)
                count = count + 1;   
                plot(dlon, dlat, color, 'linewi', 1.2); hold on
%                 ylim([-3.5, 3.5])
%                 text(dlon(end), dlat(end), num2str(neddies(ind)), 'color', 'b')
            end
    case 'west'
            if all(dlon <= 0)
                count = count + 1;   
                plot(dlon, dlat, color, 'linewi', 1.2); hold on
%                 ylim([-3.5, 3.5])
%                 text(dlon(end), dlat(end), num2str(neddies(ind)), 'color', 'b')
            end
    case 'eastandwest'
        if ~all(dlon <= 0) & ~all(dlon>=0)
            count = count + 1;   
            plot(dlon, dlat, color, 'linewi', 1.2); hold on
        end
    otherwise  
                plot(dlon, dlat, color, 'linewi', 1.2); hold on
%                 ylim([-3.5, 3.5]);
%                 text(dlon(end), dlat(end), num2str(neddies(ind)), 'color', 'b')
    end% endswitch
  
    clear eddy xlon ylat dlon dlat
end