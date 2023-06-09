function [eddies] = ra_eddiesGenDis(tracks, filter_day, index)
% This function gets eddies tracks according to their formation or
% dissipation depending on user inputs
% For generation: index = 1 and dissipation index  = 2;

elife = NaN(length(tracks),1);
for ii = 1:length(tracks)
    elife(ii) = length(tracks{ii});
end
% filter eddies
ind = find(elife >= filter_day); % Change here
for ii = 1:length(ind)
    new_tracks{ii} = tracks{ind(ii)}; %#ok
end
% == Get eddies according to user choice
switch index
    case 1
        disp('You asked eddies formation')
        eddies = get_eddiesgen(new_tracks);
    otherwise
        disp('You asked eddies dissipation')
        eddies = get_eddiesdis(new_tracks);
end
% Supporting functions
function [eddies] = get_eddiesgen(tracks)  
parfor ii = 1:length(tracks)
        eddies{ii} = tracks{ii}(1,:);
end
function [eddies] = get_eddiesdis(tracks)  
parfor ii = 1:length(tracks)
        eddies{ii} = tracks{ii}(end,:);
end