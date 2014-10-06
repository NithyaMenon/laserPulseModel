function [ outputPulses ] = delayModule( inputPulses, delayTime)
%   Inputs: inputPulses - A list of input pulses
%           delayTime - a specified time in ns all input pulses will be 
%           delayed by
%   Outputs: outputPulses - delayed output pulses
%

[nrow, ncol] = size(inputPulses);
for i = 1:nrow
    currentPulse = inputPulses(i,:);
    currentPulse(3) = delayTime + currentPulse(3); % computes delay in ns
    outputPulses = [outputPulses; currentPulse];   
end