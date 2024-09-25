function [systemLoad] = loadEstimation(loadInformation)
% avoid numerical errors
systemLoad = max(loadInformation.systemLoad, 0);
end