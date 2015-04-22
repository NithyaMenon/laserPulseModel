function [TimingPerformance, RMSE] = calculateTimingPerformance(ImportantPulses_Is,...
    ImportantPulses_times,ResidualPulses_Is,ResidualPulses_times,n,T)
    

    T = T*1e9;

    timings = transpose((ImportantPulses_times - ImportantPulses_times(1))*1e9);
    
    ff = @(w,timings) abs(1+(-1)^(n+1)*exp(1i*w*T) + ...
        sum(2*exp(1i*bsxfun(@plus,(1:n)'*pi,timings*w)),1)).^2;
    lorentzian = @(w) 10^6*2/pi./(1+(w*10^6).^2);
    
    
    idealPulseTimings = uddTimes(T,n);
    w = logspace(-6,8,1000);
    [~,uLimInd] = max(ff(w,idealPulseTimings)./w.^2);
    uLim = w(uLimInd);
    
    TimingPerformance = integral(@(w)ff(w,timings(2:end-1)).*lorentzian(w)./w.^2*2/pi,0,uLim);
    
    % Add the initial offset to the ideal pulse times
    idealPulseTimings = idealPulseTimings + timings(1);
    
    % Compute RMSE 
%    RMSE = 1/n * sqrt(sum((timings(2:end-1) - (idealPulseTimings - idealPulseTimings(1))).^2));
    
    RMSE = 1/n * sqrt(sum((timings(2:end-1) - (idealPulseTimings)).^2));
end