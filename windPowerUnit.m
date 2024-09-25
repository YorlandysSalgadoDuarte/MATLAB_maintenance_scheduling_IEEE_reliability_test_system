function [capacity] = windPowerUnit(simulationWindow, componentParameters)
% this function estimate the power capacity of the wind farm unit
% inputs:
% 0. simulationWindow: window of the simulation
% 1. componentParameters: structure including all parameters
    % 1.1. nominalPower: nominal power of the wind turbine (MW)
    % 1.2. startWind: minimum wind needed to start the turbine (km/h)
    % 1.3. nominalWind: nominal wind ot get the nominal capacity of the turbine (km/h)
    % 1.4. cutWind: for safety reasons, wind value for which the turbine should stop (km/h)
    % 1.5. windAverage: historical average of the wind (km/h)
    % 1.6. windStandardDeviation: historical deviation of the wind (km/h)

% output:
% 1. capacity: simulated power delivered (MW/h)

% code start here the code %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% estimating the wind speed with Weibull distribution
[windSpeed] = windSpeedWeibullDistribution(simulationWindow, componentParameters.windAverage, componentParameters.windStandardDeviation);

% estimating wind power
windPower = zeros(1, length(windSpeed));
for k = 1:length(windSpeed)
    [windPowerOutput] = windPowerTurbine(windSpeed(k), componentParameters.nominalPower, componentParameters.startWind, componentParameters.nominalWind, componentParameters.cutWind);
    windPower(k) = windPowerOutput;
end

% allocating the wind power in a variable
capacity = windPower;
end
% code ends here %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%