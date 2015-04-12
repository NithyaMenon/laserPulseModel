paths;
clearAll;

tic

montecarloruns = 3;

FinalResultSet = repmat(struct('N',-1,'T',-1,'TimingPerformances',[-1],...
    'PowerPerformances',[-1],'TimingStatistics',-1,'PowerStatistics',-1,'AllOutputData',-1),1,1);

N = 6; % N Pi Pulses
% T = 300e-9;
T = 2028;

FinalResultSet(1).N = N;
FinalResultSet(1).T = T;

[PCTimings1,CP1,PCTimings2,CP2,DelayLeft,DelayMiddle,DelayBottom] = ...
    runExperiment(T,N);

% PCTimings1 = [-1,1,38,40,103,105,168,170,220,222,272,274]*1e-9;
% CP1 = [0.5000,    1.0000,    1.0000,    1.0000,    1.0000,    0.5000];
% PCTimings2 = [43+8,93,183+8,243]*1e-9;
% CP2 = [1,1];
% DelayLeft = 10e-9;
% DelayMiddle = 14.33e-9;
% DelayBottom = 18.66e-9;



TimingPerformances = zeros(1,montecarloruns);
PowerPerformances = zeros(1,montecarloruns);

AllOutputData = repmat(struct('ImportantPulse_times',-1,'ImportantPulse_Is',-1,...
    'ResidualPulses_times',-1,'ResidualPulses_Is',-1,'DiffImpRes',-1),1,montecarloruns);

for l = 1:montecarloruns

    MC_initialize;
    sim('MC_DigitizingDesign.slx',(T/13e-9)+50);

    [ Pulses, Is, Qs, Us, Vs, widths, times, IDs] = ProcessSimout(simout);

    NthLargestPulse = sort(Is);
    NthLargestPulse = NthLargestPulse(end-N-1); % N+2 for Pi/2 pulses, actually.

    ImportantPulses_Is = Is(Is>=NthLargestPulse-eps);
    ResidualPulses_Is = Is(Is<NthLargestPulse-eps);
    ImportantPulses_times = times(Is>=NthLargestPulse-eps);
    ResidualPulses_times = times(Is<NthLargestPulse-eps);
    
    AllOutputData(l).ImportantPulse_times = ImportantPulses_times;
    AllOutputData(l).ImportantPulse_Is = ImportantPulses_Is;
    AllOutputData(l).ResidualPulses_times = ResidualPulses_times;
    AllOutputData(l).ResidualPulses_Is = ResidualPulses_Is;
    AllOutputData(l).DiffImpRes = log10(min(ImportantPulses_Is) - max(ResidualPulses_Is));
    

    TimingPerformances(l) = calculateTimingPerformance(ImportantPulses_Is,...
        ImportantPulses_times,ResidualPulses_Is,ResidualPulses_times,N,T);

    PowerPerformances(l) = calculatePowerPerformance(ImportantPulses_Is,...
        ImportantPulses_times,ResidualPulses_Is,ResidualPulses_times);

end

FinalResultSet(1).TimingPerformances = TimingPerformances;
FinalResultSet(1).PowerPerformances = PowerPerformances;
FinalResultSet(1).TimingStatistics = struct('Mean',mean(TimingPerformances),...
    'StdDevation', std(TimingPerformances));
FinalResultSet(1).PowerStatistics = struct('Mean',mean(PowerPerformances),...
    'StdDevation', std(PowerPerformances));
FinalResultSet(1).AllOutputData = AllOutputData;

toc