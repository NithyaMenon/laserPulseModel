function [ outputPulses ] = attenuateModule( inputPulses, attenFactor)
%   Inputs: inputPulses - A list of input pulses
%           attenFactor - a specified factor each pulse will be attenuated
%           by
%   Outputs: outputPulses - attenuated output pulses
%
outputPulses = [];

[nrow, ncol] = size(inputPulses);
for i = 1:nrow
    currentPulse = inputPulses(i,:);
    currentPulse(2) = attenFactor * currentPulse(2); % attenuates signal
    outputPulses = [outputPulses; currentPulse];   
end