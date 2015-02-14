clear;
close all;
clc;

% Delay Specification

T = 100e-9; % s
n = 8; % Do not change -- specific to slx file.
tim = @(T,n,k) T.*sin(k*pi./(2*n + 2) ).^2;
delays = tim(T,n,1:n);


% Vector of input pulse timings
num_pulses_start = 50;
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





