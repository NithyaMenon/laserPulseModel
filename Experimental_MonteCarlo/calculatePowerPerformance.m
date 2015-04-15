function PowerPerformance = calculatePowerPerformance(AllOutputData,N)

    AllPi = zeros(length(AllOutputData)*N,1);
    % Calculate Avg Intensity of Pi over all runs
    for p = 1:length(AllOutputData)
        AllPi(N*(p-1)+1:N*p) = AllOutputData(p).ImportantPulse_Is(2:end-1);
    end
    
    IdealPiIntensity = mean(AllPi);
    PowerPerformance = -ones(1,length(AllOutputData));
    for p = 1:length(AllOutputData)
        PowerErrorImportant = AllOutputData(p).ImportantPulse_Is(2:end-1)...
            - IdealPiIntensity;
        PowerErrorResidual = AllOutputData(p).ResidualPulses_Is;
        PowerPerformance(p) = sqrt(sum(PowerErrorImportant.^2) + sum(PowerErrorResidual.^2));
    end   
end