paths;
clearAll;
MC_specifyerrors;

%parpool(2);

N = 6;
Ts = [20, 40, 60, 80, 100, 120, 140]*1e-9;
%Ts=[20,40]*1e-9;
tic

montecarloruns = 2;

FinalResultSet = repmat(struct('N',-1,'T',-1,'TimingPerformances',[-1],...
    'PowerPerformances',[-1],'TimingStatistics',-1,'PowerStatistics',-1,...
    'OptimizationTarget',-1,'IdealPulse',-1,'IdealTimingPerformance',-1,...
    'AllOutputData',-1,'SimParams',-1),1,1);

%N = 4; % N Pi Pulses
%T = 300e-9;
%T = 2028e-9;

ctr = 1;


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
    for l = 1:montecarloruns
   
        MC_initialize_sp;
        sim('MC_SinglePulseN6.slx',(T/13e-9)+50);

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
    FinalResultSet(ctr).PowerStatistics = struct('Mean',mean(PowerPerformances),...
        'StdDevation', std(PowerPerformances));
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

toc