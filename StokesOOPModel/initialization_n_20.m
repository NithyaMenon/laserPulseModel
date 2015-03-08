clear;
close all;
clc;

addpath('./Graphing','./Components');

% Delay Specification

T = 300e-9; % s
n = 20; % Do not change -- specific to slx file.
tim = @(T,n,k) T.*sin(k*pi./(2*n + 2) ).^2;
delays = tim(T,n,1:n);


% Vector of input pulse timings
num_pulses_start = round(T/13e-9)+10;
timings = 0:13e-9:(num_pulses_start-1)*13e-9;

PCtimings = [-1,1]*1e-9;
controlPowers = ones(1,length(PCtimings)/2);
% controlPowers(1) = 0.5;
% controlPowers(end) = 0.5;

PockelsObject.clearPockels();
PC1 = PockelsObject(PCtimings,controlPowers);


% Pulse sequence creation
Pulse.clearPulses();
inputsignal = zeros(length(timings)+100,1);

for i = 1:length(timings)
    pulse = Pulse([timings(i)]);
    inputsignal(i) = pulse.ID;
end





