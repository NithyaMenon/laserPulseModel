function PowerPerformance = calculatePowerPerformance(AllOutputData,N)
    
    % calculatePowerPerformance.m - Evaluate the power performance of a
    % given Simulink run
    % INPUTS - 
    %    AllOutputData - output data from Simulink model
    %    N - number of pi pulses
    % OUTPUTS -
    %   PowerPerformance - square root of the sum of the squared power error from the average
    %   pi pulse power and residual pulse power
    

    AllPi = zeros(length(AllOutputData)*N,1);
    
    % Calculate Avg Intensity of pi pulses over all runs
    for p = 1:length(AllOutputData)
        AllPi(N*(p-1)+1:N*p) = AllOutputData(p).ImportantPulse_Is(2:end-1);
    end
    
    IdealPiIntensity = mean(AllPi);
    PowerPerformance = -ones(1,length(AllOutputData));
    
    % Compute difference in power error
    for p = 1:length(AllOutputData)
        % Measure power error of output pi pulses with respect to the mean
        % pi pulse power
        PowerErrorImportant = AllOutputData(p).ImportantPulse_Is(2:end-1)...
            - IdealPiIntensity;
        % Measure power error of residual pulses with respect to zero
        PowerErrorResidual = AllOutputData(p).ResidualPulses_Is;
        
        % Take the square root of the sum of the squared power errors to
        % define the output power error metric
        PowerPerformance(p) = sqrt(sum(PowerErrorImportant.^2) + sum(PowerErrorResidual.^2));
    end   
end