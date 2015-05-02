function [TimingPerformance,RMSE,seqFail] =  calculatePulsePickerPerformance(N,T);

    % calculatePulsePickerPerformance - calculate overlap integral, RMSE,
    % and power performance for a given N and T
    % INPUTS
    %   N - number of pi pulses
    %   T - total pulse sequence length
    % OUTPUTS
    %   TimingPerformance - Overlap integral performance 
    %   RMSE - root mean squared error from ideal sequence
    %   N - number of pi pulses
    %   T - total sequence duration

    global ErrorSpecs;
    if ~isfield(ErrorSpecs,'Pulse')
        Err = 0;
    else
        Err = ErrorSpecs.Pulse.Time*1e9;
    end
    plotting = 0;

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
        if plotting
            figure();
            stem(Timings,ones(size(Timings)));
            hold on;
            stem(ideal,ones(size(ideal)));
            stem(pulseTrain,0.5*ones(size(pulseTrain)));
            hold off;
            legend('Pulse Picker','UDD','Train');
        end

        % Compute timing and RMSE performance
        [TimingPerformance,RMSE] = calculateTimingPerformance([],Timings/1e9,...
            [],[],N,T/1e9);

        % idealPerformance = calculateIdealTimingPerformance(N,T/1e9);
    else
        TimingPerformance = -1;
        RMSE = -1;
    end


end