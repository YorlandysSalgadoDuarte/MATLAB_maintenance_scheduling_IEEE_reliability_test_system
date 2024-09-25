function [windSpeed] = windSpeedWeibullDistribution(simulationWindow, windAverage, windStandardDeviation)
% this function estimate the wind speed
% inputs:
% 0. simulationWindow: window of the simulation
% 1. windAverage: historical average of the wind (m/s)
% 2. windStandardDeviation: historical deviation of the wind (m/s)

% output:
% 1. windSpeed: wind speed (m/s)

% code start here the code %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% estimating parameters Weibull distribution
shape = (windStandardDeviation / windAverage).^(-1.086);
scale = windAverage / gamma(1 + (1 / shape));
% simulating the wind Weibull distribution
windSpeed = random('Weibull', scale, shape, 1, simulationWindow);
% avoid negative values
windSpeed = max(windSpeed, 0);
end
% code ends here %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%