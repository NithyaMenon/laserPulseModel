function [ transmitPulses ] = beamCombineModule( inputPulses, transmitPercentage, totalTime)
%   Inputs: inputPulses - A list of input pulses
%           transmitPercentage - a fraction where the percentage reflected is
%               1 - transmitPercentage
%           totalTime - totalTime of our sequence 
%   Outputs: transmitPulse
%
% This beamsplitter is for recombining two paths in our optical setup

% Need to use the total time to compute our pulse train and check for
% interference
fs = 800E8;    
t = 0 : 1/fs : totalTime;
w = 3*10^(-9);
pulseTrain = pulstran(t, [], @rectpuls,w);
for i = 1:length(inputPulses),
        currentSequence = inputPulses{i};       
        inputPeriod = 1/currentSequence{1};
        D = 0 : inputPeriod : totalTime;
        currentTrain = pulstran(t, D, @rectpuls, w);
        
        pulseTrain = pulseTrain + currentTrain;
end

%plot(t*1E6, pulseTrain);

if max(pulseTrain) > 1.01
    disp('ERROR: Pulses are interferring!')
end

transmitPulses = {};
for i = 1:length(inputPulses),
    currentSequence = inputPulses{i};
    currentSequence{5} = currentSequence{5} * (1-transmitPercentage);
    transmitPulses = [transmitPulses; currentSequence];
end
    
end





