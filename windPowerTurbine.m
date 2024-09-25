function [windPower] = windPowerTurbine(windSpeed, nominalPower, startWind, nominalWind, cutWind)
% this function estimate the wind power
% inputs:
% 1. windSpeed: random wind speed number simulated with Weibull distribution (m/s)
% 2. nominalPower: nominal power of the wind turbine (MW)
% 3. startWind: minimum wind needed to start the turbine (m/s)
% 4. nominalWind: nominal wind ot get the nominal capacity of the turbine (m/s)
% 5. cutWind: for safety reasons, wind value for which the turbine should stop (m/s)

% output:
% 1. windPower: power delivered by a given wind speed (MW)

% code start here the code %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% estimating constanst given the inputs
A = (1/(startWind - nominalWind).^2) * (startWind * (startWind + nominalWind) - 4 * startWind * nominalWind * ((startWind + nominalWind)/(2 * nominalWind)).^3);
B = (1/(startWind - nominalWind).^2) * ((4 * (startWind + nominalWind) * ((startWind + nominalWind)/(2 * nominalWind)).^3) - (3 * startWind + nominalWind));
C = (1/(startWind - nominalWind).^2) * ((2 - 4 * ((startWind + nominalWind)/(2 * nominalWind)).^3));
% power turbine function, section fucntion
if windSpeed < startWind && windSpeed > 0
    windPower = 0;
elseif windSpeed < nominalWind && windSpeed >= startWind
    windPower = nominalPower * (A + B * windSpeed + C * windSpeed.^2);
elseif windSpeed <= cutWind && windSpeed >= nominalWind
    windPower = nominalPower;
else
    windPower = 0;
end
% avoid negative values
windPower = max(windPower, 0);
end
% code ends here %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%