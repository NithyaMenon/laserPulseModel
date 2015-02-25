clear
Pulse.clearPulses();
PockelsObject.clearPockels();
close all
clc



PC1 = PockelsObject([0,5,20,25]);

p1 = Pulse([10e-9]);

PC1.applyPockels(p1,pi/4);

Pulse.printStateHistory(p1);