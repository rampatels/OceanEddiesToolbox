function [etraveldist] = ra_eddytravel(n_eddies, eddy_id, eddy_x, eddy_y)
% This function computes the total distance travelled by eddies
% INPUTS: n_eddies = unique eddy id list
% eddy_id = list of all eddies id
% eddy_x(y) = eddies centre position.
% This function excepts the data stright from the eddies_t structure.
% example, travel = ra_eddytravel(unique(eddies_t.id), eddies_t.id, eddies_t.x, eddies_t.y)

etravel = NaN(size(n_eddies));
for ind = 1:length(n_eddies)
    %
    eddy = eddy_id == n_eddies(ind);
    %
    xlon = eddy_x(eddy); ylat = eddy_y(eddy);
    % computing distance 
    distance = gsw_distance(xlon, ylat)/1000; % distance in km
    distance = cat(1, 0, cumsum(distance));
    etravel(ind) = distance(end);   
    clear eddy xlon ylat distance
end

etraveldist = etravel;