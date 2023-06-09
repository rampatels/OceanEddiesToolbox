function [lonc, latc, bin_count] = ra_eddiesDensity(eddies_centers, lonst, lonen, latst, laten, wid_box)
% This function counts number of eddies in the grid box
% INPUT: eddies_centers(lon, lat) = m x 2 matrix with first column
% is longitude and second column is latitute of an eddy centre location.
% wid_box = box dimension in degree; 1 means 1x1 degree box.

wid = wid_box;

lonc = lonst:wid:lonen;   nx = length(lonc);
latc = latst:wid:laten;   ny = length(latc);

lon_e = eddies_centers(:,1);
lat_e = eddies_centers(:,2);

bin_count = zeros(nx,ny);

for ix = 1:nx
    
    for iy = 1:ny
        
        xc = lonc(ix);
        yc = latc(iy);
        
        lon_range = [-wid, +wid]./2 + xc;
        lat_range = [-wid, +wid]./2 + yc;
        
        for ie = 1:length(lon_e)
            
            xe = lon_e(ie);
            ye = lat_e(ie);
            
            if(xe > lon_range(1) && xe < lon_range(end) && ye > lat_range(1) && ye < lat_range(end))
                bin_count(ix,iy) = bin_count(ix,iy)+1;
            end

        end
        
    end
    
end