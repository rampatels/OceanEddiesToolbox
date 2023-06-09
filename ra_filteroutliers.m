function [newseries] = ra_filteroutliers(series, factor)
% This function filters outliers from the series assumming non-gaussian
% distribution of the series
% INPUT: series - series from which you would like to remove outliers
% factor - usually 1.5 is default but if you want to remove only extreme
% outliers than use 3. If you leave this input empty then 1.5 is assumed

if ((nargin < 1) || (nargin > 2))
   error('ra_filteroutliers.m: Must pass minimum 1 parameters')
end 
% Optional value
if (nargin == 1)
    factor = [];
    str = 'U R using factor of 1.5';
    warning(['ra_filteroutliers.m: ', str])  %#ok<WNTAG>
end
if (isempty(factor))
    factor = 1.5 ; 
end

% Computing IQR for the series
IQR  = iqr(series);
cutoff = IQR * factor;

% Calculating 25th and 75th percentile
limits = quantile(series, [0.25, 0.75]);

% Computing limits for filtering outliers
lower = limits(1) - cutoff; % lower than 25th percentile
upper = limits(2) + cutoff; % higher than 75th percentile

% Creating new series
newseries = series(series > lower & series < upper);