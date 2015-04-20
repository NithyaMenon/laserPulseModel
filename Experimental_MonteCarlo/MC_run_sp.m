paths;
clearAll;
MC_specifyerrors;

%parpool(2);

tic

montecarloruns = 1;

FinalResultSet = repmat(struct('N',-1,'T',-1,'TimingPerformances',[-1],...
    'PowerPerformances',[-1],'TimingStatistics',-1,'PowerStatistics',-1,...
    'OptimizationTarget',-1,'IdealPulse',-1,'IdealTimingPerformance',-1,...
    'AllOutputData',-1,'SimParams',-1),1,1);

N = 4; % N Pi Pulses
T = 300e-9;
%T = 2028e-9;

idealPulseTimes = uddTimes(T,N);
FinalResultSet(1).N = N;
FinalResultSet(1).T = T;

[PCTimings1,CP1,delTimes] = runExperiment_sp(T*1e9,N);

% PCTimings1 = [-1,1,38,40,103,105,168,170,220,222,272,274]*1e-9;
% CP1 = [0.5000,    1.0000,    1.0000,    1.0000,    1.0000,    0.5000];
% PCTimings2 = [43+8,93,183+8,243]*1e-9;
% CP2 = [1,1];
% DelayLeft = 10e-9;
% DelayMiddle = 14.33e-9;
% DelayBottom = 18.66e-9;

%%

TimingPerformancesFF = zeros(1,montecarloruns);
TimingPerformancesMSE = zeros(1,montecarloruns);
PowerPerformances = zeros(1,montecarloruns);

AllOutputData = repmat(struct('ImportantPulse_times',-1,'ImportantPulse_Is',-1,...
    'ResidualPulses_times',-1,'ResidualPulses_Is',-1,'DiffImpRes',-1),1,montecarloruns);
for l = 1:montecarloruns
   
    MC_initialize_sp;
    sim('MC_SinglePulseN4.slx',(T/13e-9)+50);

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

FinalResultSet(1).TimingPerformances = [TimingPerformancesFF;TimingPerformancesMSE];
FinalResultSet(1).PowerPerformances = calculatePowerPerformance(AllOutputData,N);
FinalResultSet(1).TimingStatistics = struct('Mean',mean([TimingPerformancesFF;TimingPerformancesMSE],2),...
    'StdDevation', std([TimingPerformancesFF;TimingPerformancesMSE],0,2));
FinalResultSet(1).PowerStatistics = struct('Mean',mean(PowerPerformances),...
    'StdDevation', std(PowerPerformances));
%FinalResultSet(1).OptimizationTarget = optVal;
FinalResultSet(1).IdealPulse = idealPulseTimes*10^9;
FinalResultSet(1).AllOutputData = AllOutputData;
FinalResultSet(1).IdealTimingPerformance = calculateIdealTimingPerformance(N,T);

% SimParams = repmat(struct('DelayLeft',-1,'DelayBottom',-1,'DelayMiddle',-1,...
%     'PCTimings1',-1,'PCTimings2',-1),1,1);
% 
% SimParams.DelayLeft = DelayLeft;
% SimParams.DelayBottom = DelayBottom;
% SimParams.DelayMiddle = DelayMiddle;
% SimParams.PCTimings1 = PCTimings1;
% SimParams.PCTimings2 = PCTimings2;
%     
% FinalResultSet(1).SimParams = SimParams;


toc