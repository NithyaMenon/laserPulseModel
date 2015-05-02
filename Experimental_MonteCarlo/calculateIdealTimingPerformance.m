function idealTimingPerformance = calculateIdealTimingPerformance(n,T)
    %idealTimingPerformace.m - Script to evaluate overlap integral using
    %   UDD Times
    % INPUTS -
    %   n - Number of pi pulses in the UDD sequence
    %   T - total sequenece duration in nano seconds
    % OUTPUTS -
    %   idealTimingPerformance - overlap integral computed using UDD times
    %       for the given n and T

    T = T*1e9;
    
    idealTimings = uddTimes(T,n);

    % Define the filter function
    ffIdeal =  @(w,idealTimings) abs(1+(-1)^(n+1)*exp(1i*w*T) + ...
        sum(2*exp(1i*bsxfun(@plus,(1:n)'*pi,idealTimings*w)),1)).^2;
    
    % Specify upper bound
    w = logspace(-6,8,1000);
    [~,uLimInd] = max(ffIdeal(w,idealTimings)./w.^2);
    uLim = w(uLimInd);
    
    % Compute noise and corresponding overlap integral 
    lorentzian = @(w) 10^6*2/pi./(1+(w*10^6).^2);
    idealTimingPerformance = integral(@(w)ffIdeal(w,idealTimings).*lorentzian(w)./w.^2*2/pi,0,uLim);
    
end