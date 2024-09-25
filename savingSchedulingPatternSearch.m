function [stop, optnew, changed] = savingSchedulingPatternSearch(optimValues, optold, flag)
% DO NOT set options, state, or flag!
% do not stop the process
stop = false;
optnew = optold;
changed = false;
% save the schedduling proposed and the evaluation
outputFiles = fullfile(pwd, 'outputData');
save(fullfile(outputFiles, 'resultsPatternSearch.mat'))
end