%%
clearAll;
close all
clc

MC_specifyerrors;

Ns = [6, 10 ,16, 24, 30];
Ts = [299, 1001, 1300, 2002, 2600, 3003]*1e-9;
% Results = repmat(struct('N',-1,'T',-1,'IdealPerformance',-1,'TimingPerformance',-1,'RMSE',-1,'seqFail',-1),5*6,1);
PulsePickerTimingPerformances = -ones(length(Ns),length(Ts));
RMSEs = -ones(length(Ns),length(Ts));
idealPerformances = RMSEs;


ctr = 1;
i = 0;
j = 0;
for N = Ns;
    i = i+1;
    j = 0;
    for T = Ts;
        j = j+1;
        [TimingPerformance, RMSE, seqFail] = calculatePulsePickerPerformance(N,T);
        idealPerformance = calculateIdealTimingPerformance(N,T);
        idealPerformances(i,j) = idealPerformance;
        if TimingPerformance ~= -1
            PulsePickerTimingPerformances(i,j) = TimingPerformance;
            RMSEs(i,j) = RMSE;
        else
            PulsePickerTimingPerformances(i,j) = NaN;
            RMSEs(i,j) = NaN;
        end
    end
end