paths;
clearAll;
MC_specifyerrors;


Ns = [6, 10 ,16, 24, 30];
Ts = [299, 1001, 1300, 2002, 2600, 3003]*1e-9;

w = warning ('off','all');
FinalResultSet = repmat(struct('N',-1,'T',-1,'TimingPerformances',[-1],...
            'PowerPerformances',[-1],'TimingStatistics',-1,'PowerStatistics',-1,...
            'OptimizationTarget',-1,'IdealPulse',-1,'IdealTimingPerformance',-1,...
            'AllOutputData',-1,'SimParams',-1),length(Ns)*length(Ts),1);

montecarloruns = 1;

tic

ctr = 1;

for N = Ns
    for T = Ts
        if((N+2)*13e-9 >= T)
            continue
        end
        
        

        idealPulseTimes = uddTimes(T,N);
        FinalResultSet(ctr).N = N;
        FinalResultSet(ctr).T = T;

        [PCTimings1,CP1,PCTimings2,CP2,DelayLeft,DelayMiddle,DelayBottom,optVal] = ...
            runExperiment(T*1e9,N);

        SimParams = repmat(struct('DelayLeft',-1,'DelayBottom',-1,'DelayMiddle',-1,...
            'PCTimings1',-1,'PCTimings2',-1),1,1);

        SimParams.DelayLeft = DelayLeft;
        SimParams.DelayBottom = DelayBottom;
        SimParams.DelayMiddle = DelayMiddle;
        SimParams.PCTimings1 = PCTimings1;
        SimParams.PCTimings2 = PCTimings2;

        FinalResultSet(ctr).SimParams = SimParams;
        FinalResultSet(ctr).OptimizationTarget = optVal;

        

        TimingPerformancesFF = zeros(1,montecarloruns);
        TimingPerformancesRMSE = zeros(1,montecarloruns);
        PowerPerformances = zeros(1,montecarloruns);

        AllOutputData = repmat(struct('ImportantPulse_times',-1,'ImportantPulse_Is',-1,...
            'ResidualPulses_times',-1,'ResidualPulses_Is',-1,'DiffImpRes',-1),1,montecarloruns);
        for l = 1:montecarloruns
            display(sprintf('N: %i, T: %i, MC: %i',N,int16(T*1e9),l));



            MC_initialize;
            sim('MC_DigitizingDesign.slx',(T/13e-9)+50);

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


            [TimingPerformance, RMSE] = calculateTimingPerformance(ImportantPulses_Is,...
                ImportantPulses_times,ResidualPulses_Is,ResidualPulses_times,N,T);

            TimingPerformancesFF(l) = TimingPerformance;
            TimingPerformancesRMSE(l) = RMSE;
        end

        FinalResultSet(ctr).TimingPerformances = [TimingPerformancesFF;TimingPerformancesRMSE];
        FinalResultSet(ctr).PowerPerformances = calculatePowerPerformance(AllOutputData,N);
        FinalResultSet(ctr).TimingStatistics = struct('Mean',mean([TimingPerformancesFF;TimingPerformancesRMSE],2),...
            'StdDevation', std([TimingPerformancesFF;TimingPerformancesRMSE],0,2));
        FinalResultSet(ctr).PowerStatistics = struct('Mean',mean(PowerPerformances),...
            'StdDevation', std(PowerPerformances));
        FinalResultSet(ctr).IdealPulse = idealPulseTimes*10^9;
        FinalResultSet(ctr).AllOutputData = AllOutputData;
        FinalResultSet(ctr).IdealTimingPerformance = calculateIdealTimingPerformance(N,T);
    end
end








toc