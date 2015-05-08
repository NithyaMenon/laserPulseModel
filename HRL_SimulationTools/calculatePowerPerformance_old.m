function PowerPerformance = calculatePowerPerformance(ImportantPulses_Is,...
    ImportantPulses_times,ResidualPulses_Is,ResidualPulses_times)

    idealPi2 = ImportantPulses_Is(1);
    idealPi = 2*idealPi2;
    PowerErrorImportant = [ImportantPulses_Is(1) - idealPi2,...
        ImportantPulses_Is(2:end-1) - idealPi, ImportantPulses_Is(end) - idealPi2];
    PowerErrorResidual = ResidualPulses_Is;
    PowerPerformance = sqrt(sum(PowerErrorImportant.^2) + sum(PowerErrorResidual.^2));    
end