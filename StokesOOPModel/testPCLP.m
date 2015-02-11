clear
close all
Pulse.clearPulses();
clc

p1 = Pulse([0]);

% Circular Polarizer
linearPolarizer([1,pi/4]); % [ id, axis angle ]
pockelsCell([1,0,1,0]); % [ id, timing, size_timing, axis angle ]
