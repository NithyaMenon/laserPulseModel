function [ outputPulses ] = wireModule( inputPulses, wireLength )
%   Inputs: inputPulse [frequency, amplitude, offset, polarization, power],
%           wireLength (meters)
%   Outputs: modulated output pulse

[nrow, ncol] = size(inputPulses);

wireDelay = (wireLength / (2.99792458 * 10^8))*10^9;
outputPulses = [];
for i = 1:nrow
    currentPulse = inputPulses(i,:);
    currentPulse(3) = wireDelay + currentPulse(3); % computes delay in ns
    outputPulses = [outputPulses; currentPulse];   
end