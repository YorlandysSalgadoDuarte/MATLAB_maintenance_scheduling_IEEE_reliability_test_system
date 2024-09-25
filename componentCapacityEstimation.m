function [componentCapacity] = componentCapacityEstimation(componentType, maintenanceScheduling, durationFirstMaintenance, timeOperationBetweenMaintenance, timeDurationMaintenance, pdObjectFail, pdObjectRepair, componentParameters, simulationWindow)
% data type validation
validateComponentType(componentType)
% remove the zeros in the maintenance structure
timeOperationBetweenMaintenance(timeOperationBetweenMaintenance == 0) = [];
timeOperationBetweenMaintenance = [maintenanceScheduling, timeOperationBetweenMaintenance];
timeDurationMaintenance(timeDurationMaintenance == 0) = [];
timeDurationMaintenance = [durationFirstMaintenance, timeDurationMaintenance];
% stochastics simulation of failures and repair time
% allocating for memory
timeToFailChain = zeros(1, simulationWindow);
timeToRepairChain = zeros(1, simulationWindow);
for k = 1:simulationWindow
    % failures case 
    % random independent samples from pd object
    timeToFail = random(pdObjectFail{1, 1}, 1, 1);
    
    % repairs case
    % random independent samples from pd object
    timeToRepair = random(pdObjectRepair{1, 1}, 1, 1);

    % criterial for the simulation windows
    timeToFailChain(1, k) = ceil(timeToFail);
    timeToRepairChain(1, k) = ceil(timeToRepair);
    if sum(sum(timeToFailChain) + sum(timeToRepairChain)) >= simulationWindow
        % control, when the restriction met
        timeToFailChain = timeToFailChain(1, 1:k);
        timeToRepairChain = timeToRepairChain(1, 1:k);
        break
    end
end

% degradation
degradation = [];
for n = 1:length(timeToFailChain)
    a = [ones(1, timeToFailChain(n)), zeros(1, timeToRepairChain(n))];
    degradation = [degradation, a];
end

% maintenance
maintenance = [];
for n = 1:length(timeOperationBetweenMaintenance)
    a = [ones(1, timeOperationBetweenMaintenance(n)), zeros(1, timeDurationMaintenance(n))];
    maintenance = [maintenance, a];
end
if length(maintenance) <= simulationWindow; maintenance = [maintenance, ones(1, simulationWindow - length(maintenance))]; end

% vector with the capacity: degradation and maintenance
% taking only values as the simulation window
degradation = degradation(1:simulationWindow);
maintenance = maintenance(1:simulationWindow);

switch componentType
    case "Wind"
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
        
    case {"OilSteam", "OilCT", "CoalSteam", "Nuclear", "Hydro"}
        capacity = ones(1, simulationWindow) * componentParameters.nominalPower;
    
    otherwise
        disp("no supported component")
end
componentCapacity = capacity .* and(degradation, maintenance);
end