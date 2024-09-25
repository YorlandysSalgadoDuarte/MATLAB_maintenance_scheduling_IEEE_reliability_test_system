function [time, x, fval, exitflag, output] = pattern_search_optimization()
% This function coordinate the maintenance process for a technical system
% the structure dataBase contains the information related to the components
%--the code start here-----------------------------------------------------
clc; clear; % clear all
% load the database
inputFiles = fullfile(pwd, "inputData");
% there are four parameterizations
% 1. dataBaseIEEE_RTS_01: Maintenance Scheduling as RTS paper.
% 2. dataBaseIEEE_RTS_02: Maintenance scheduling with dispersion
% 3. dataBaseIEEE_RTS_03: Maintenance scheduling with dispersion and wind farms
% to be selected
databaseName = "dataBaseIEEE_RTS_01.mat";
structure = load(fullfile(inputFiles, databaseName));
dataBase = structure.dataBase; clear structure inputFiles
% start the optimization process
objectiveFunction = @(x)simulation(x, dataBase); % Monte Carlo method, option to be used %objectiveFunction = @(x)sum(x); % Testing convergency
nvars = length(dataBase.systemComponentsInformation.componentID); % number of variables
disp(["simulationWindow", dataBase.simulationParameters.simulationWindow, "hours"]) % windows of the simulation (8760 hours)
% window of the simulation (8760 hours)
% allocate for speed
UB = zeros(1, length(dataBase.systemComponentsInformation.componentID));
% loop to guarantee maintenance scheduling within the simulation window
for k = 1:length(dataBase.systemComponentsInformation.componentID)
    for m = 1:length(dataBase.systemComponentsInformation.timeOperationBetweenMaintenance{k, 1})
        UB(1, k) = dataBase.simulationParameters.simulationWindow - (dataBase.systemComponentsInformation.durationFirstMaintenance(k) + sum(cell2mat(dataBase.systemComponentsInformation.timeOperationBetweenMaintenance{k, 1})) + sum(cell2mat(dataBase.systemComponentsInformation.timeDurationMaintenance{k, 1})));
    end
end
LB = dataBase.systemComponentsInformation.startFirstMaintenance'; % lower bound
rng('default') % control random number generation
% initial conditions
% the following approach is proposed knowing the features of the reliability oriented scheduling
% floor of the interval
floorInt = min(UB);
% estimating initial intervals
interval = floor(floorInt/nvars);
x0 = cumsum(interval * ones(1, length(UB)));
% run the optimization function
% the function variate the initial start time of the maintenance and evaluate the impact of the proposed plan in the system, therefore, the solution is the best pland
% setting for the optimization algorithm
options = optimoptions("patternsearch", 'Display', 'iter', 'PlotFcn', @psplotbestf, 'OutputFcn', @savingSchedulingPatternSearch, UseParallel = true, AccelerateMesh = true);
[x, fval, exitflag, output] = patternsearch(objectiveFunction, x0, [], [], [], [], LB, UB, [], options); % find minimum of function using pattern search
x = round(x); % results of the model
% translate hours to date
time = schedulingDatetime(x);
%-- the code ends here-----------------------------------------------------
end