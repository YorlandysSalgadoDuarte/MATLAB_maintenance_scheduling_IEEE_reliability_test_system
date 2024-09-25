% this function coordinate the maintenance process for a technical system
% the structure dataBase contains the information related with the cranes
% clear all
clc; clear; % clear all
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
% run the function
% solution scheduling proposed

% trivial solution, no maintenance is considered with database 00
%x = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];

% Roy Billinton with database 01
%x = [5544 5208 2184 1008 1008 5544 5208 2856 2184 6384 4536 3528 2184 1344 504 3360 6048 5712 2688 1176 5040 4536 6720 6048 4368 1680 6552 2352 1512 5208 1680 5880];

% Mahmud FOTUHI-FIRUZABAD 01 with database 01
%x = [5880 4032 3528 7224 5208 3528 2856 7224 7224 5040 3192 5208 3528 5880 3528 504 1176 5712 1848 4536 5880 5208 2520 4368 1008 6720 2352 1680 5208 6384 5712 1512];

% Mahmud FOTUHI-FIRUZABAD 02 with database 01
%x = [5880 6720 5880 4536 5880 6384 6720 2016 2688 2688 6384 2688 5880 2352 5880 1848 5712 1848 1344 5712 6384 5208 6384 1512 5208 2184 6048 1680 1680 6384 1680 5880];

% Moein Manbachi with database 01
%x = [5880 2352 1344 1512 4704 6888 6552 1680 6384 1512 1512 5880 1848 1512 6384 5712 1680 2184 5712 2016 6048 6552 2016 6552 1512 6384 6384 2016 1512 5712 1512 5712];

% Salgado Duarte solution PSO with database 01 2020
x = [2527 7257 7885 3317 327 1809 4331 7248 1872 4190 405 5072 4318 4222 1849 5043 5540 5002 7 6719 5523 5041 6376 3006 5959 4434 1828 1305 6514 970 5512 2015];

% risk indicator estimation without variance reduction
% simulation function
tic
%dataBase.simulationParameters.simulationError = 0.01;
%dataBase.simulationParameters.simulationWindow = 8736;
[fval_1] = simulation(x, dataBase);
toc
% translate hours to date
%time = schedulingDatetime(x);