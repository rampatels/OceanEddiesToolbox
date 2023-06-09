function T = ra_eddystat(characteristics)
% This function prepares the table of statistics for a given eddy
% characteristics
% since eddy properties are skewed the best measure of the central tendency
% of the data and dispersion is median and interquartile range
% for sake of minimum value and maximum value, I compute minimum value at
% 5th percentile and maximum value at 95th percentile of the data

Median = median(characteristics);
IQR = iqr(characteristics);
min5th = prctile(characteristics, 5);
max95th = prctile(characteristics, 95);

T = table(min5th, max95th , Median, IQR);
