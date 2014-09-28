function [ outputPulse ] = wireModule( inputPulse, wireLength )
%UNTITLED Summary of this function goes here
%   Inputs: inputPulse [frequency, amplitude, offset, polarization, power],
%           wireLength (meters)
%   Outputs: modulated output pulse

inputPulse(3) = (wireLength / (2.99792458 * 10^8))*10^9; % computes delay in ns
outputPulse = inputPulse;
end

