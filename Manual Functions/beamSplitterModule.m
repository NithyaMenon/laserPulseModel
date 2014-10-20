function [ transmitPulses, reflectedPulses ] = beamSplitterModule( inputPulses, transmitPercentage)
%   Inputs: inputPulse, transmitPercentage (where the percentage reflected
%           is 1 - transmitPercentage) 
%   Outputs: transmitPulse, reflectedPulse 

[nrows, ncol] = size(inputPulses);

transmitPulses = [];
reflectedPulses = [];

for i = 1:nrows,
    currentPulse = inputPulses(i,:);
    transmitPulse = currentPulse;
    transmitPulse(2) = currentPulse(2) * transmitPercentage;
    reflectedPulse = currentPulse;
    reflectedPulse(2) = currentPulse(2) * (1-transmitPercentage);
    
    transmitPulses = [transmitPulses; transmitPulse];
    reflectedPulses = [reflectedPulses; reflectedPulse];
end

