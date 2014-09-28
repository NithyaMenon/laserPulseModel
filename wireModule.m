function [ outputPulse ] = wireModule( inputPulse, wireLength )
%   Inputs: inputPulse [frequency, amplitude, offset, polarization, power],
%           wireLength (meters)
%   Outputs: modulated output pulse

inputPulse(3) = (wireLength / (2.99792458 * 10^8))*10^9 + inputPulse(3); % computes delay in ns
outputPulse = inputPulse;
end

