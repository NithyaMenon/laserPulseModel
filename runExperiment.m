function [eomOnTimes, eomOffTimes] = runExperiment(T,n)
% top-level function to run delay optimization and automation, then pass
% inputs to the Simulink model

[~,digTimes,bestDelays,~] = delOp(T,n,false);

[eomOnTimes,eomOffTimes] = automate(T,n,digTimes,bestDelays);
end