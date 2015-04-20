function idealTimingPerformance = calculateIdealTimingPerformance(n,T)
    

    T = T*1e9;
    target = 17.317171337233528; % Change. This is only for N=6
    
    idealPulseTimes = uddTimes(T,n);
    idealTimings = idealPulseTimes;
    
    ffIdeal =  @(w,idealTimings) abs(1+(-1)^(n+1)*exp(1i*w*T) + ...
        sum(2*exp(1i*bsxfun(@plus,(1:n)'*pi,idealTimings*w)),1)).^2;
    
    lorentzian = @(w) 10^6*2/pi./(1+(w*10^6).^2);
    idealTimingPerformance = integral(@(w)ffIdeal(w,idealTimings).*lorentzian(w)./w.^2,0,target/T);
    
end