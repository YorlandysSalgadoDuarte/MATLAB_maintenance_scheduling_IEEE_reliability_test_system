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
databaseName = "dataBaseIEEE_RTS_04.mat";
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
% x = [2527 7257 7885 3317 327 1809 4331 7248 1872 4190 405 5072 4318 4222 1849 5043 5540 5002 7 6719 5523 5041 6376 3006 5959 4434 1828 1305 6514 970 5512 2015];

% Salgado Duarte solution PSO with database 03 2024
x = [1126 1514 7752 5627 4456 4805 1431 7346 4961 6489 5656 5717 30 449 3799 0 3862 5813 3784 5536 273 4565 5355 2649 6071 331 592 1640 1001 3982 401 3792 2129 923 1935 4128 4180 4333 4392 931 1521 1125 1771 564 3126 4016 9 4388 1008 3399 2465 837 4357 921 3823 1641 4392 1208 4192 1054 3883 696 2335 3401 1117 108 2814 2519 1973 4321 392 2023 2087 1985 318 3988 1506 2181 1625 308 4119 203 828 3105 2410 55 4236 14 2437 3248 3140 437 1148 3469 4196 4119 4296 3257 2403 3659 4389 3631 3906 1944 888 1072 965 1359 3786 415 2134 23 1242 2883 3841 2001 1014 3801 2001 4377 85 1829 4232 1535 3408 190 2140 3164 2167 3879 2335 698 1479 1130 148 4083 79 2405 794 21 1355 3707 3210 3057 194 3934 2921 450 979 4152 2718 741 3202 38 1316 1433 2742 2139 3723 1459 3102 6 2704 2 139 2327 2126 2398 3244 1903 22 2924 4229 1850 106 2480 3145 3309 3171];

% risk indicator estimation without variance reduction
% simulation function
tic
%dataBase.simulationParameters.simulationError = 0.01;
%dataBase.simulationParameters.simulationWindow = 8736;
[fval_1] = simulation(x, dataBase);
toc
% translate hours to date
%time = schedulingDatetime(x);