function [state, options, optchanged] = savingSchedulingGeneticAlgorithm(options, state, flag)
% DO NOT stop the process
optchanged = false;
% save the schedduling proposed and the evaluation
outputFiles = fullfile(pwd, 'outputData');
save(fullfile(outputFiles, 'resultsGeneticAlgorithm.mat'))
end