clear
close all
Pulse.clearPulses();
clc


p1 = Pulse([0]);
p2 = Pulse([1]);

linearPolarizer([1,2,0]);
pockelsCell([1,2,1,1]);
linearPolarizer([1,2,1]);
