function [PCTimings1, CP1, delTimes] = runExperiment_sp(T,N)
% top-level function to run delay optimization and automation, then pass
% inputs to the Simulink model
% example input: T=2028,n=6;
% outputs:
% PCTimings1, a row vector of alternating EOM on and off times, in seconds
% CP1, the power of the EOM (is always 1, for the single pulse)
% delTimes, a row vector of the delay times in seconds.
[eomOnTimes, eomOffTimes, delTimes] = automate_sp(T,N);

PCTimings1(1) = eomOnTimes*10^-9;
PCTimings1(2) = eomOffTimes*10^-9;
CP1 = 1;
delTimes=delTimes*10^-9;
end