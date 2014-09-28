function [ transmitPulse, reflectedPulse ] = beamSplitterModule( inputPulse, transmitPercentage)
%   Inputs: inputPulse, transmitPercentage (where the percentage reflected
%           is 1 - transmitPercentage) 
%   Outputs: transmitPulse, reflectedPulse 


transmitPulse = inputPulse;
transmitPulse(5) = inputPulse(5) * transmitPercentage;
reflectedPulse = inputPulse;
reflectedPulse(5) = inputPulse(5) * (1-transmitPercentage);







end

