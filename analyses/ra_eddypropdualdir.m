function count = ra_eddypropdualdir(n_eddies, eddy_id, eddy_x, eddy_y, dualpuredir, color)
% This function plots pathways that eddies assumes from their origin while
% centered at their formation location. 
% NOTE: puredir - eddy movement from the center 
% dualpuredir = 'north-east' or 'south-west', 'north-west', 'south-west'
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

    switch dualpuredir
    case 'south-east'
            if dlat <= 0 & dlon >= 0
                count = count + 1;   
                plot(dlon, dlat, color, 'linewi', 1.2); hold on
%                 ylim([-3.5, 3.5])
%                 text(dlon(end), dlat(end), num2str(neddies(ind)), 'color', 'b')
            end
    case 'north-east'
            if dlat >= 0 & dlon >= 0
                count = count + 1;   
                plot(dlon, dlat, color, 'linewi', 1.2); hold on
%                 ylim([-3.5, 3.5])
%                 text(dlon(end), dlat(end), num2str(neddies(ind)), 'color', 'b')
            end
    case 'south-west'
            if dlat <= 0 & dlon <= 0
                count = count + 1;   
                plot(dlon, dlat, color, 'linewi', 1.2); hold on
%                 ylim([-3.5, 3.5])
%                 text(dlon(end), dlat(end), num2str(neddies(ind)), 'color', 'b')
            end
    case 'north-west'
            if dlat >= 0 & dlon <= 0
                count = count + 1;   
                plot(dlon, dlat, color, 'linewi', 1.2); hold on
%                 ylim([-3.5, 3.5])
%                 text(dlon(end), dlat(end), num2str(neddies(ind)), 'color', 'b')
            end
    otherwise  
%                 plot(dlon, dlat, color, 'linewi', 1.2); hold on
%                 ylim([-3.5, 3.5]);
%                 text(dlon(end), dlat(end), num2str(neddies(ind)), 'color', 'b')
    end% endswitch
  
    clear eddy xlon ylat dlon dlat
end