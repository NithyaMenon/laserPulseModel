function [TimingPerformance,RMSE,seqFail] =  calculatePulsePickerPerformance(N,T);
    
    global ErrorSpecs;
    if ~isfield(ErrorSpecs,'Pulse')
        Err = 0;
    else
        Err = ErrorSpecs.Pulse.Time*1e9;
    end

    T = T*1e9;

    ideal = [0;uddTimes(T,N);T];
    Errs = Err*randn(size(ideal));
    pulseTrain = 0:13:T+13;

    inds = -ones(size(ideal));
    for i = 1:length(ideal)
        val = ideal(i);
        [~,ind] = min(abs(pulseTrain - val));
        inds(i) = ind;
    end

    seqFail = length(unique(inds)) ~= length(inds);

    if ~seqFail

        Timings = pulseTrain(inds) + transpose(Errs);

        [TimingPerformance,RMSE] = calculateTimingPerformance([],Timings/1e9,...
            [],[],N,T/1e9);

        % idealPerformance = calculateIdealTimingPerformance(N,T/1e9);
    else
        TimingPerformance = -1;
        RMSE = -1;
    end


end