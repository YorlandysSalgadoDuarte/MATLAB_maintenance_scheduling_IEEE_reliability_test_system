function [capacity] = thermalPowerUnit(simulationWindow, componentParameters)
% this function estimate the power capacity of the thermal unit
% inputs:
% 0. simulationWindow: window of the simulation
% 1. componentParameters: structure including all parameters
    % 1.1. nominalPower: nominal power of the thermal unit (MW)

% output:
% 1. capacity: simulated power delivered (MW/h)

% code start here the code %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% allocating the simulated delivered power in a variable
capacity = ones(1, simulationWindow) * componentParameters.nominalPower;
end
% code ends here %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%