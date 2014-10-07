function [] = pulseSequenceDisplay( inputPulses, totalTime)

% Inputs: inputPulses - A list of input pulses
%           
% Outputs: A plot of the inputPulse sequences

fs = 800E8;    
t = 0 : 1/fs : totalTime;
w = 3*10^(-9);
pulseTrain = pulstran(t, [], @rectpuls,w);

[nrow, ncol] = size(inputPulses);
for i = 1:nrow,
        currentSequence = inputPulses(i,:);       
        inputPeriod = 1/currentSequence(1);
        D = currentSequence(3) : inputPeriod : totalTime;
        currentTrain = currentSequence(2)*pulstran(t, D, @rectpuls, w);
        pulseTrain = pulseTrain + currentTrain;
end

plot(t*1E6, pulseTrain);
