clear;
close all;
clc;

% Delay Specification

delays = [10e-9, 14.33e-9, 18.66e-9];

PCtimings1 = [0, 39, 104, 169, 221, 273]*1e-9;
PCtimings2 = [43:2:93, 183:2:243]*1e-9;


% Vector of input pulse timings
num_pulses_start = 100;
timings = 0:13e-9:(num_pulses_start-1)*13e-9;

PCtimings = [13e-9 ]; % Change based on application.
% Note on PCtimings: Last element must indicate number of timings

% Pulse sequence creation
Pulse.clearPulses();
inputsignal = zeros(length(timings)+100,1);

for i = 1:length(timings)
    pulse = Pulse([timings(i)]);
    inputsignal(i) = pulse.ID;
end





