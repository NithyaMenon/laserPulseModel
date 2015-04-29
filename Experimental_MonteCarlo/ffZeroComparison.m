function results=ffZeroComparison(Tvec,nvec)
% runs delOp with various parameters to generate upper/lower bounds on
% performance
%
% index n by row and T by column

    if size(Tvec,2)==1
        Tvec = Tvec';
    end
    if size(nvec,1)==1
        nvec = nvec';
    end

    TSize = size(Tvec,2);
    nSize = size(nvec,1);

    omega = logspace(-8,8,5000);
    ffZero = @(w,T) abs(1-exp(1i*w*T)).^2./w.^2;
    lorentzian = @(w) 10^6*2/pi./(1+(w*10^6).^2);

    ub = zeros(1,TSize);
    
    for TInd = 1:TSize
        [~,ubInd] = max(ffZero(omega,Tvec(TInd)));
        ub(TInd) = omega(ubInd);
    end

    results = Tvec;

    for TInd = 1:TSize
        [~,ubInd] = max(ffZero(omega,Tvec(TInd)));
        ub = omega(ubInd);
        results(TInd) = quad(@(w) ffZero(w,Tvec(TInd)).*lorentzian(w)*2/pi,0,ub);
    end
end