paths;
clearAll;


n = 6;
T = 300e-9;

% [PCTimings1,CP1,PCTimings2,CP2,DelayLeft,DelayMiddle,DelayBottom] = ...
%     getAutomation(n,T);

PCTimings1 = [-1,1,38,40,103,105,168,170,220,222,272,274]*1e-9;
CP1 = [0.5000,    1.0000,    1.0000,    1.0000,    1.0000,    0.5000];
PCTimings2 = [43+8,93,183+8,243]*1e-9;
CP2 = [1,1];
DelayLeft = 10e-9;
DelayMiddle = 14.33e-9;
DelayBottom = 18.66e-9;

MC_initialize;
sim('MC_DigitizingDesign.slx',(T/13e-9)+50);

[ Pulses, Is, Qs, Us, Vs, widths, times, IDs] = ProcessSimout(simout);

ImportantPulses_Is = Is(Is>1e-4);
ResidualPulses_Is = Is(Is<=1e-4);
ImportantPulses_times = times(Is>1e-4);
ResidualPulses_times = times(Is<=1e-4);

% TimingPerformance = calculateTimingPerformance(ImportantPulses_Is,...
%     ImportantPulses_times,ResidualPulses_Is,ResidualPulses_times);



