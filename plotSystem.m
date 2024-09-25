function [s] = plotSystem(s, risk, meanRisk, expectedEnergyNotSupplied, error, simulationWindow, loadProduction, systemCapacity)

% figure with the expected value estimation
figure(1);
subplot(2,2,1)
plot(risk(1, 1:s));
hold on
plot(meanRisk(1, 1:s));
hold off
xlabel('Iterations', 'FontSize', 8);
ylabel('Expected Energy Not Supplied (MWh/yr)', 'FontSize', 8);
grid on
legend('Simulated Value', 'Expected Value')
temp1 = 'Risk Value:';
temp2 = 'MWh/yr';
temp3 = 'Simulation error:';
riskValue = num2str(expectedEnergyNotSupplied);
errorValue = num2str(error);
riskTitle = strcat(temp1,{' '}, riskValue,{' '}, temp2, {' '}, {' '}, temp3, {' '}, errorValue);
title(riskTitle, 'FontSize', 8)

% figure with the capcity vs load
figure(1)
subplot(2,2,2)
%t = 1:simulationWindow;
%plot(t, loadProduction, t, systemCapacity);
area(systemCapacity)
hold on
area(loadProduction)
hold off
ylabel('System capacity (MW)', 'FontSize', 8);
xlabel('Hours/Year', 'FontSize', 8);
grid on
xlim([0 simulationWindow]);
ylim([min(loadProduction) max(systemCapacity)]);
title(riskTitle , 'FontSize', 8)

% figure with the frequency histogram
figure(1)
subplot(2,2,3)
h = histogram(risk(1, 1:s));
AxesPlot = h.Parent;
hold on
ylabel('Frequency', 'FontSize', 8);
xlabel('Risk Value', 'FontSize', 8);
title(riskTitle, 'FontSize', 8)
plot([expectedEnergyNotSupplied, expectedEnergyNotSupplied], [AxesPlot.YLim(1), AxesPlot.YLim(2)])
hold off
end