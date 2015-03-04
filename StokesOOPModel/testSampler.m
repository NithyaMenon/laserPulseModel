clear
clc

Pulse.clearPulses();
PockelsObject.clearPockels();
samplePulseObject.clearsamplePulseObjects();

p1 = Pulse([]);
p2 = Pulse([]);
linearPolarizer([1,pi/2]);
linearPolarizer([2,0]);


out = signalSampler([1,2]);


