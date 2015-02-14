clear
close all
Pulse.clearPulses();
clc

p1 = Pulse([0]); % Will pass
p2 = Pulse([1]); % Will get blocked


display(p1) % Unpolarized
display(p2) % Unpolarized

linearPolarizer([1,2,0]); % [ id, axis angle ]
pockelsCell([1,2,0,1,pi/4]); % [ id, timing, size_timing, axis angle ]
linearPolarizer([1,2,pi/2]);
display(p1) % Vertical polarization
display(p2) % Blocked