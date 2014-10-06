function [ outputPulses ] = attenuateModule( inputPulses, attenFactor)
%   Inputs: inputPulses - A list of input pulses
%           attenFactor - a specified factor each pulse will be attenuated
%           by
%   Outputs: outputPulses - attenuated output pulses
%

[nrow, ncol] = size(inputPulses);
for i = 1:nrow
    currentPulse = inputPulses(i,:);
    currentPulse(5) = attenFactor * currentPulse(5); % attenuates signal
    outputPulses = [outputPulses; currentPulse];   
end