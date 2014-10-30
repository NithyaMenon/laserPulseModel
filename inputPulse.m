function outputSequence = inputPulse( repRate, power, offset, polarization, totalTime)

%INPUTPULSE Summary of this function goes here
%   Detailed explanation goes here

fs = 800E8;    
t = 0 : 1/fs : totalTime;
w = 3*10^(-9);
inputPeriod = 1/repRate;

D = offset : inputPeriod : totalTime; 

pulseTrain = pulstran(t, D, @rectpuls,w);

pulseTrain = power*pulseTrain;

outputSequence = timeseries(pulseTrain, t, 'name', 'sequence');
outputSequence.UserData = polarization;


    
end

