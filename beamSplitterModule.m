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
    transmitPulse(5) = currentPulse(5) * transmitPercentage;
    reflectedPulse = currentPulse;
    reflectedPulse(5) = currentPulse(5) * (1-transmitPercentage);
    
    transmitPulses = [transmitPulses; transmitPulse];
    reflectedPulses = [reflectedPulses; reflectedPulse];
end

