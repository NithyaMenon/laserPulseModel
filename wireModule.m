function [ outputPulse ] = wireModule( inputPulse, wireLength )
%UNTITLED Summary of this function goes here
%   Inputs: inputPulse [frequency, amplitude, offset, polarization, power],
%           wireLength (meters)
%   Outputs: modulated output pulse

inputPulse(3) = wireLength; %% calculate offset here
outputPulse = inputPulse;
end

