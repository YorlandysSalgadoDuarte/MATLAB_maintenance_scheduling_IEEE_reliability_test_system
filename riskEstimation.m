function [valueAtRisk, systemLoad, systemCapacity, componentCapacity] = riskEstimation(maintenanceScheduling, timeOperationBetweenMaintenance, timeDurationMaintenance, dataBase)
% function to assess the impact of the maintenance scheduling
% system capacity modeling
% allocate for speed
componentCapacity = zeros(length(dataBase.systemComponentsInformation.componentID), dataBase.simulationParameters.simulationWindow);
% stochastic capacity estimation for each component
% simulate independent random values
% estimating the stochastic availability
for k = 1:length(dataBase.systemComponentsInformation.componentID)
    [componentCapacity(k, :)] = componentCapacityEstimation(dataBase.systemComponentsInformation.componentType(k), maintenanceScheduling(k), dataBase.systemComponentsInformation.durationFirstMaintenance(k), timeOperationBetweenMaintenance(k, :), timeDurationMaintenance(k, :), dataBase.systemComponentsInformation.pdObjectFail(k), dataBase.systemComponentsInformation.pdObjectRepair(k), dataBase.systemComponentsInformation.componentParameters{k}, dataBase.simulationParameters.simulationWindow);
end
% system capacity modeling, block diagram
% block diagram
% allocate for speed
systemCapacity = zeros(1, dataBase.simulationParameters.simulationWindow);
% modelling serie components
individualComponents = unique(dataBase.systemComponentsInformation.blockDiagram);
dataSetParallel = zeros(length(dataBase.systemComponentsInformation.componentID), dataBase.simulationParameters.simulationWindow);
for m = 1:length(individualComponents)
    dataSetSerie = componentCapacity(dataBase.systemComponentsInformation.componentNumber(dataBase.systemComponentsInformation.blockDiagram == individualComponents(m)), :);
    subSystem = zeros(1, dataBase.simulationParameters.simulationWindow);
    for k = 1:dataBase.simulationParameters.simulationWindow
        if min(dataSetSerie(:, k)) ~= 0
            subSystem(1, k) = min(dataSetSerie(:, k));
        else
            subSystem(1, k) = 0;
        end
    end
    dataSetParallel(m, :) = subSystem;
end
% modelling parallel components
for k = 1:dataBase.simulationParameters.simulationWindow
    systemCapacity(1, k) = sum(dataSetParallel(1:m, k));
end
% modelling load estimation
[systemLoad] = loadEstimation(dataBase.loadInformation);
% convolution
valueAtRisk = max(systemLoad - systemCapacity, 0);
end