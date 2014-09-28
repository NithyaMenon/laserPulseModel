function [ outputPulse ] = halfWavePlateModule( inputPulse, angle)
%   Input: inputPulse, angle (between polarization vector and direction of
%          propagation along the waveplate's fast axis)
%   Output: outputPulse
outputPulse = inputPulse;
if inputPulse(4) == 0 && angle == 45; % vertical polarization
    outputPulse(4) = 1;
elseif inputPulse(4) == 1 && angle == 45; % horizontal polarization
    outputPulse(4) = 0;
end
end

