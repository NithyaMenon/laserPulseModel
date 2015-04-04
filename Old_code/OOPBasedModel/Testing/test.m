clear
Pulse.clearPulses();
close all
clc

p1 = Pulse([]);
p2 = Pulse([]);

t = beamSplitterTransmit([1,2,0.5]);
r = beamSplitterReflect([1,2,0.5]);
