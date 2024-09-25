function [stop, optnew, changed] = savingSchedulingSurrogate(optimValues, optold, flag)
% DO NOT set options, state, or flag!
% do not stop the process
stop = false;
% save the schedduling proposed and the evaluation
outputFiles = fullfile(pwd, 'outputData');
save(fullfile(outputFiles, 'resultsSurrogate.mat'))
end