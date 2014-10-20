function [ outputPulses ] = halfWavePlateModule( inputPulses, angle)
%   Input: inputPulse, angle (between polarization vector and direction of
%          propagation along the waveplate's fast axis)
%   Output: outputPulse

[nrow, ncol] = size(inputPulses);
outputPulses = [];
for i = 1:nrow,
    currentPulse = inputPulses(i,:);
    if currentPulse(4) == 0 && angle == 45; % vertical polarization
        currentPulse(4) = 1;
    elseif currentPulse(4) == 1 && angle == 45; % horizontal polarization
        currentPulse(4) = 0;
    end
    outputPulses = [outputPulses; currentPulse];
end

