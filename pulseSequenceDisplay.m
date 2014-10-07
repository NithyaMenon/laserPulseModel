function [pulseTrain] = pulseSequenceDisplay( inputPulses, totalTime)

% Inputs: inputPulses - A list of input pulses
%           
% Outputs: A vector of the input pulse values

fs = 800E8;    
t = 0 : 1/fs : totalTime;
w = 3*10^(-9);
pulseTrain = pulstran(t, [], @rectpuls,w);

for i = 1:size(inputPulses),
        currentSequence = inputPulses(i,:);       
        inputPeriod = 1/currentSequence(1);
        D = currentSequence(3) : inputPeriod : totalTime;
        currentTrain = currentSequence(2)*pulstran(t, D, @rectpuls, w);
        pulseTrain = pulseTrain + currentTrain;
end

