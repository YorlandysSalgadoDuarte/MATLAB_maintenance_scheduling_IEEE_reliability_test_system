%% function to plot the maintenance scheduling for all the components considered
function [x] = schedulingPlots(x, componentID, durationFirstMaintenance, timeOperationBetweenMaintenance, timeDurationMaintenance, plotWindow, expectedEnergyNotSupplied, error)
figure(1)
subplot(2,2,4)
numberOfComponents = length(x);
for j = 1:numberOfComponents
    operationTasks = cumsum([x(j) cell2mat(timeOperationBetweenMaintenance{j, 1})]);
    durationTasks = [durationFirstMaintenance(j) cell2mat(timeDurationMaintenance{j, 1})];
    for k = 1:length(operationTasks)
        plot([operationTasks(k), operationTasks(k) + durationTasks(k)], [(j), (j)], 'b', 'Linewidth', numberOfComponents*5/numberOfComponents);
        hold on
    end
end
xlabel('Hours/Year', 'FontSize', 8);
grid on
xlim(plotWindow);
ylim([0 (length(x) + 1)]);
ylabel = char(categorical(componentID));
set(gca,'ytick', 1:length(componentID), 'yticklabel', ylabel, 'FontSize', 6)
temp1 = 'Maintenance Scheduling Results, Risk Value:';
temp2 = 'MWh/year';
temp3 = 'Simulation error:';
riskValue = num2str(expectedEnergyNotSupplied);
errorValue = num2str(error);
riskTitle = strcat(temp1,{' '}, riskValue,{' '}, temp2, {' '}, {' '}, temp3, {' '}, errorValue);
title(riskTitle, 'FontSize', 8)
hold off
end