% MC_run.m - Script to initialize and run the Monte Carlo model, to the run
% the simulation, specify a range of N and T and number of Monte Carlo
% models below and press the "run" button in the above MATLAB toolbar. The
% simulation will use the .slx file listed in the below for loop. This
% script is currently configured to perform Monte Carlo simulations of the
% single pulse design drawn in a variety of schematics

% Clear the workspace to prepare for simulation
paths;
clearAll;

% Use MC_specifyerrors to specify the global component errors to be sampled
% for each Monte Carlo run for every component error listed in MC_specifyerrors 
MC_specifyerrors;

w = warning ('off','all');
%parpool(2);
Ns = 10;
Ts = 60*1e-9;
%Ns = [4,6,8];
%Ts = [20, 40, 60, 80, 100, 120, 140]*1e-9;
%Ts=[20]*1e-9


tic1 = tic;

montecarloruns = 1;

FinalResultSet = repmat(struct('N',-1,'T',-1,'TimingPerformances',[-1],...
    'PowerPerformances',[-1],'TimingStatistics',-1,'PowerStatistics',-1,...
    'OptimizationTarget',-1,'IdealPulse',-1,'IdealTimingPerformance',-1,...
    'AllOutputData',-1,'SimParams',-1),1,1);

%N = 4; % N Pi Pulses
%T = 300e-9;
%T = 2028e-9;

ctr = 1;

for N = Ns
    for T = Ts

        idealPulseTimes = uddTimes(T,N);
        FinalResultSet(ctr).N = N;
        FinalResultSet(ctr).T = T;

        SimParams = repmat(struct('Delays',-1,'PCTimings1',-1),1,1);

        [PCTimings1,CP1,delTimes] = runExperiment_sp(T*1e9,N);

        SimParams.Delays = delTimes;
        SimParams.PCTimings1 = PCTimings1;

        TimingPerformancesFF = zeros(1,montecarloruns);
        TimingPerformancesMSE = zeros(1,montecarloruns);
        PowerPerformances = zeros(1,montecarloruns);

        FinalResultSet(ctr).SimParams = SimParams;

        AllOutputData = repmat(struct('ImportantPulse_times',-1,'ImportantPulse_Is',-1,...
        'ResidualPulses_times',-1,'ResidualPulses_Is',-1,'DiffImpRes',-1),1,montecarloruns);
        tic2 = tic;
        for l = 1:montecarloruns
            timmy = toc(tic2);
            display(sprintf('N: %i, T: %f, Run: %i, PrevRunTime: %f', N, T*1e9, l, timmy))
            tic2 = tic;
            MC_initialize_sp;

            switch N
                case 4
                    sim('MC_SinglePulseN4.slx',(T/13e-9)+50);
                case 6
                    sim('MC_SinglePulseN6.slx',(T/13e-9)+50);
                case 8
                    sim('MC_SinglePulseN8.slx',(T/13e-9)+50);
                case 10
                    sim('MC_SinglePulseN10.slx',(T/13e-9)+50);
            end


            [ Pulses, Is, Qs, Us, Vs, widths, times, IDs] = ProcessSimout(simout);

            NthLargestPulse = sort(Is);
            NthLargestPulse = NthLargestPulse(end-N-1); % N+2 for Pi/2 pulses, actually.

            ImportantPulses_Is = Is(Is>=NthLargestPulse-eps);
            ResidualPulses_Is = Is(Is<NthLargestPulse-eps);
            ImportantPulses_times = times(Is>=NthLargestPulse-eps);
            ResidualPulses_times = times(Is<NthLargestPulse-eps);

            AllOutputData(l).ImportantPulse_times = ImportantPulses_times*10^9;
            AllOutputData(l).ImportantPulse_Is = ImportantPulses_Is;
            AllOutputData(l).ResidualPulses_times = ResidualPulses_times;
            AllOutputData(l).ResidualPulses_Is = ResidualPulses_Is;
            AllOutputData(l).DiffImpRes = log10(min(ImportantPulses_Is) - max(ResidualPulses_Is));
            AllOutputData(l).SampledErrors = SampledErrors;


            [TimingPerformance, MSE] = calculateTimingPerformance(ImportantPulses_Is,...
            ImportantPulses_times,ResidualPulses_Is,ResidualPulses_times,N,T);

            TimingPerformancesFF(l) = TimingPerformance;
            TimingPerformancesMSE(l) = MSE;
        end

        FinalResultSet(ctr).TimingPerformances = [TimingPerformancesFF;TimingPerformancesMSE];
        FinalResultSet(ctr).PowerPerformances = calculatePowerPerformance(AllOutputData,N);
        FinalResultSet(ctr).TimingStatistics = struct('Mean',mean([TimingPerformancesFF;TimingPerformancesMSE],2),...
            'StdDevation', std([TimingPerformancesFF;TimingPerformancesMSE],0,2));
        FinalResultSet(ctr).PowerStatistics = struct('Mean',mean(FinalResultSet(ctr).PowerPerformances),...
            'StdDevation', std(FinalResultSet(ctr).PowerPerformances));
        %FinalResultSet(1).OptimizationTarget = optVal;
        FinalResultSet(ctr).IdealPulse = idealPulseTimes*10^9;
        FinalResultSet(ctr).AllOutputData = AllOutputData;
        FinalResultSet(ctr).IdealTimingPerformance = calculateIdealTimingPerformance(N,T);

        SimParams = repmat(struct('DelayTimes',-1,'PCTimings1',-1),1,1);

        SimParams.DelayTimes = delTimes;
        SimParams.PCTimings1 = PCTimings1;

        FinalResultSet(1).SimParams = SimParams;

        ctr = ctr + 1;
    end
end

toc(tic1);