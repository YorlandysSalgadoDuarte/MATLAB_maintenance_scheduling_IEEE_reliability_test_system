function y = simulation(x, dataBase)
x = round(x); % rounding the value
maintenanceScheduling = x'; % shaping format
% initial parameters, maintenence parameters, units
% initialization of maintenance data, allocate for speed
timeOperationBetweenMaintenance = zeros(length(dataBase.systemComponentsInformation.componentID), dataBase.simulationParameters.maxNumberOfMaintenance);
timeDurationMaintenance = zeros(length(dataBase.systemComponentsInformation.componentID), dataBase.simulationParameters.maxNumberOfMaintenance);
% allocate the maintenance data from the database
for k = 1:length(dataBase.systemComponentsInformation.componentID)
    for m = 1:length(dataBase.systemComponentsInformation.timeOperationBetweenMaintenance{k, 1})
        timeDurationMaintenance(k, m) = dataBase.systemComponentsInformation.timeDurationMaintenance{k, 1}{1, m};
        timeOperationBetweenMaintenance(k, m) = dataBase.systemComponentsInformation.timeOperationBetweenMaintenance{k, 1}{1, m};
    end
end
% simulation of system capacity & system load
% initialization for speed for all the loops
risk = zeros(1, dataBase.simulationParameters.maxNumberOfSimulations);
meanRisk = zeros(1, dataBase.simulationParameters.maxNumberOfSimulations);
stdRisk = zeros(1, dataBase.simulationParameters.maxNumberOfSimulations);
% loop with the simulation
rng("default") % control random number generation
for s = 1:dataBase.simulationParameters.maxNumberOfSimulations
    [valueAtRisk, systemLoad, systemCapacity, ~] = riskEstimation(maintenanceScheduling, timeOperationBetweenMaintenance, timeDurationMaintenance, dataBase); % risk estimation: convolution
    risk(1, s) = sum(valueAtRisk); % risk vector estimation, MWh/yr
    meanRisk(1, s) = mean(risk(1, 1:s)); % risk value
    stdRisk(1, s) = std(risk(1, 1:s)); % variability of the risk estimation
    error = stdRisk(1, s) / (meanRisk(1, s) * sqrt(s)); % error of the risk estimation
    expectedEnergyNotSupplied = meanRisk(1, s); % allocate the value of the risk in a new variable
    [~] = plotSystem(s, risk, meanRisk, expectedEnergyNotSupplied, error, dataBase.simulationParameters.simulationWindow, systemLoad, systemCapacity); % dynamic plot window
    % initialization and control error
    % disp(s); disp(error); disp(risk(1, s)); disp(expectedEnergyNotSupplied)
    if s ~= 1 && s >= dataBase.simulationParameters.minNumberOfSimulations && stdRisk(1, s) / (meanRisk(1, s) * sqrt(s)) <= dataBase.simulationParameters.simulationError
        break
    end
end
% finish the loop of the simulation
% plot with the scheduling
plotWindow = [0 dataBase.simulationParameters.plotSimulationWindow]; % defining the plot windows
[~] = schedulingPlots(x, dataBase.systemComponentsInformation.componentID, dataBase.systemComponentsInformation.durationFirstMaintenance, dataBase.systemComponentsInformation.timeOperationBetweenMaintenance, dataBase.systemComponentsInformation.timeDurationMaintenance, plotWindow, expectedEnergyNotSupplied, error); % ploting the results
y = expectedEnergyNotSupplied; % indicator to evaluate the scenario, optimization target
% finish the scenario
end