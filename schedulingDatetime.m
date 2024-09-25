function [time] = schedulingDatetime(x)
% this function convert from hours to datetime for reporting
% inputs:
% 1. x: vector with the start-time-to-maintenance (h), the value must be between zero and the simulation window.

% output:
% 1. time: start-time-to-maintenance expressed in a calendar year.

% code start here the code %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initialization
t0 = datenum('1900-01-01 00:00:00', 'yyyy-mm-dd HH:MM:SS');
% shifting
time = x / 24 + t0;
% conversion
time = datetime(time, 'ConvertFrom', 'datenum');
% transpose
time = time';
end
% code ends here %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%