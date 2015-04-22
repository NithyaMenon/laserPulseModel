function [PCTimings1, CP1, PCTimings2, CP2,DelayLeft,DelayMiddle,DelayBottom,optVal,seqFail] = runExperiment(T,n)
% top-level function to run delay optimization and automation, then pass
% inputs to the Simulink model
% example input: T=2028,n=6;

[~,digTimes,bestDelays,optVal] = delOp(T,n,false);

[eomOnTimes,eomOffTimes, ppEomOnTimes, ppEomOffTimes, delTimes, seqFail] = automate(T,n,digTimes,bestDelays);

PCTimings1 = zeros(1,length(ppEomOnTimes)+length(ppEomOffTimes));
PCTimings1(1:2:end)=ppEomOnTimes;
PCTimings1(2:2:end)=ppEomOffTimes;
PCTimings1 = PCTimings1 + 26e-9;
PCTimings2 = zeros(1,length(eomOnTimes)+length(eomOffTimes));
PCTimings2(1:2:end)=eomOnTimes;
PCTimings2(2:2:end)=eomOffTimes;
PCTimings2 = PCTimings2 + 26e-9;
CP1 = [0.5000, ones(1,length(ppEomOnTimes)-2), 0.5000];
CP2 = ones(1,length(eomOnTimes));
DelayLeft=delTimes(1)*1e-9;
DelayMiddle=delTimes(2)*1e-9;
DelayBottom=delTimes(3)*1e-9;
end