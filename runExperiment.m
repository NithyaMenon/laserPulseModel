function [PCTimings1, CP1, PCTimings2, CP2,DelayLeft,DelayMiddle,DelayBottom] = runExperiment(T,n)
% top-level function to run delay optimization and automation, then pass
% inputs to the Simulink model
% example input: T=2028,n=6;

[~,digTimes,bestDelays,~] = delOp(T,n,false);

[eomOnTimes,eomOffTimes, ppEomOnTimes, ppEomOffTimes] = automate(T,n,digTimes,bestDelays);

PCTimings1 = zeros(1,length(ppEomOnTimes)+length(ppEomOffTimes));
PCTimings1(1:2:end)=ppEomOnTimes;
PCTimings1(2:2:end)=ppEomOffTimes;
PCTimings2 = zeros(1,length(eomOnTimes)+length(eomOffTimes));
PCTimings2(1:2:end)=eomOnTimes;
PCTimings2(2:2:end)=eomOffTimes;
CP1 = [0.5000, ones(1,length(ppEomOnTimes)-2), 0.5000];
CP2 = [ones(1,length(eomOnTimes))];
DelayLeft=digTimes(1)*10^-9;
DelayMiddle=digTimes(2)*10^-9;
DelayBottom=digTimes(3)*10^-9;
end