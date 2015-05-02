function [TimingPerformance, RMSE] = calculateTimingPerformance(ImportantPulses_Is,...
    ImportantPulses_times,ResidualPulses_Is,ResidualPulses_times,n,T)
    
    % calculateTimingPerformance - compute timing metrics for a given
    % simulation
    %
    % INPUTS - 
    %   ImportantPulses_Is - intensity of the largest N+2 pulses
    %   ImportantPulses_times - pulse timings of the largest N+2 pulses
    %   ResidualPulses_Is - intensity of residual pulses
    %   ResidualPulses_times - residual pulse times
    %   N - number of pi pulses
    %   T - total sequence length
    

    T = T*1e9;

    % Scale important pulses times to make sure the first Pi/2 pulse occurs
    % at a time of zero
    timings = transpose((ImportantPulses_times - ImportantPulses_times(1))*1e9);
    
    % Define filter function and noise
    ff = @(w,timings) abs(1+(-1)^(n+1)*exp(1i*w*T) + ...
        sum(2*exp(1i*bsxfun(@plus,(1:n)'*pi,timings*w)),1)).^2;
    lorentzian = @(w) 10^6*2/pi./(1+(w*10^6).^2);
    
    % Compute ideal UDD times, first Pi/2 pulse occurs at a time of zero
    idealPulseTimings = uddTimes(T,n);
    
    % Define the max frequency of the overlap integral
    w = logspace(-6,8,1000);
    [~,uLimInd] = max(ff(w,idealPulseTimings)./w.^2);
    uLim = w(uLimInd);
    
    % Compute the filter function
    TimingPerformance = integral(@(w)ff(w,timings(2:end-1)).*lorentzian(w)./w.^2*2/pi,0,uLim);
    
    % Add the initial offset to the ideal pulse times
    idealPulseTimings = idealPulseTimings + timings(1);
    
    % Compute RMSE relative to the ideal pulse timings
%    RMSE = 1/n * sqrt(sum((timings(2:end-1) - (idealPulseTimings - idealPulseTimings(1))).^2));
    RMSE = 1/n * sqrt(sum((timings(2:end-1) - (idealPulseTimings)).^2));
end