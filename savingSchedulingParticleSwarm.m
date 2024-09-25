function stop = savingSchedulingParticleSwarm(optimValues, state)
% do not stop the process
stop = false;
% save the schedduling proposed and the evaluation
outputFiles = fullfile(pwd, 'outputData');
save(fullfile(outputFiles, 'resultsParticleSwarm.mat'))
end