clear;
close all;
clc;

% Specify a desired n and T
n = 6;
T = 300*10^-9;

% Delay Specification

delays = [];

% PCtimings1 = [0, 39, 104, 169, 221, 273]*1e-9;
% PCtimings2 = [43:2:93, 183:2:243]*1e-9;

% Vector of input pulse timings
num_pulses_start = 100;
timings = 0:13e-9:(num_pulses_start-1)*13e-9;

uddTimes =(pi/(2*n+2):pi/(2*n+2):n*pi/(2*n+2))';
uddSequence = T*sin(uddTimes).^2;

PCtimings1 = [];

for i = 1:length(uddSequence)
    [nearestPulseTime, nearestPulseIndex] = min(abs(timings - uddSequence(i)));
    nearestPulseIndex;
    onTime = timings(nearestPulseIndex);
    offTime = onTime + 2*10^-9;
    PCtimings1 = [PCtimings1 onTime offTime];
end

PCtimings1 = PCtimings1;
 
controlPowers1 = ones(1,length(PCtimings1)/2);
controlPowers1(1) = 0.5;
controlPowers1(end) = 0.5;

PCtimings1
controlPowers1

PockelsObject.clearPockels();
PC1 = PockelsObject(PCtimings1,controlPowers1);


% Pulse sequence creation
Pulse.clearPulses();
inputsignal = zeros(length(timings)+100,1);

for i = 1:length(timings)
    pulse = Pulse([timings(i)]);
    inputsignal(i) = pulse.ID;
end





