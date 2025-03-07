function [valueAtRisk, systemLoad, systemCapacity, componentCapacity] = riskEstimation(maintenanceScheduling, timeOperationBetweenMaintenance, timeDurationMaintenance, dataBase)
% function to assess the impact of the maintenance scheduling
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% here we introduce the simulations using copula, specifically Gaussian copula.
% the idea is to simulate random correlated samples between zero and one, then scale up using the Weibull model for wind.
% using the information in the database, first filter all wind farms.
% there is one assumption, the list of wind farms must be at the end of the database.
windFarms = dataBase.systemComponentsInformation(strcmp(dataBase.systemComponentsInformation.componentType,"Wind"), :);
% then check count of wind turbines in each wind farm
windFarmsIDs = split(windFarms.componentID,"-");
numberOfWindFarms = unique(str2double(windFarmsIDs(:,2)));
numberOfWindTurbines = histcounts(str2double(windFarmsIDs(:,2)), [unique(str2double(windFarmsIDs(:,2)))', inf])';
% generate random numbers correlated for each wind farm
info = table(numberOfWindFarms, numberOfWindTurbines);
% for each win farm, different correlations
% wind farm 1
v_1 = ones(1, table2array(info(1, 2)));
rho_1 = diag(v_1);
rho_1(rho_1==0) = 0.99; % to be change during the experiment.
u_1 = copularnd("Gaussian", rho_1, dataBase.simulationParameters.simulationWindow)';
% wind farm 2
v_2 = ones(1, table2array(info(2, 2)));
rho_2 = diag(v_2);
rho_2(rho_2==0) = 0.99; % to be change during the experiment.
u_2 = copularnd("Gaussian", rho_2, dataBase.simulationParameters.simulationWindow)';
% wind farm 3
v_3 = ones(1, table2array(info(3, 2)));
rho_3 = diag(v_3);
rho_3(rho_3==0) = 0.99; % to be change during the experiment.
u_3 = copularnd("Gaussian", rho_3, dataBase.simulationParameters.simulationWindow)';
% merge the matrices in only one to be used in the simulation of the winds.
u = [u_1; u_2; u_3];
% create a table with the information
windRandomValuesData = table(windFarms.componentID, u);
% windRandomValuesData = [];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% system capacity modeling
% allocate for speed
componentCapacity = zeros(length(dataBase.systemComponentsInformation.componentID), dataBase.simulationParameters.simulationWindow);
% stochastic capacity estimation for each component
% simulate independent random values
% estimating the stochastic availability
for k = 1:length(dataBase.systemComponentsInformation.componentID)
    [componentCapacity(k, :)] = componentCapacityEstimation(windRandomValuesData, dataBase.systemComponentsInformation.componentID(k), dataBase.systemComponentsInformation.componentType(k), maintenanceScheduling(k), dataBase.systemComponentsInformation.durationFirstMaintenance(k), timeOperationBetweenMaintenance(k, :), timeDurationMaintenance(k, :), dataBase.systemComponentsInformation.pdObjectFail(k), dataBase.systemComponentsInformation.pdObjectRepair(k), dataBase.systemComponentsInformation.componentParameters{k}, dataBase.simulationParameters.simulationWindow);
end
% system capacity modeling, block diagram
% block diagram
% allocate for speed
systemCapacity = zeros(1, dataBase.simulationParameters.simulationWindow);
% modeling series components
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
% modeling parallel components
for k = 1:dataBase.simulationParameters.simulationWindow
    systemCapacity(1, k) = sum(dataSetParallel(1:m, k));
end
% modeling load estimation
[systemLoad] = loadEstimation(dataBase.loadInformation);
% convolution
valueAtRisk = max(systemLoad - systemCapacity, 0);
end