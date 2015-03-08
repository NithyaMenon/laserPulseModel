pat = fileparts(pwd());
addpath(strcat(pat,'/Graphing'),strcat(pat,'/Components'));


clear;
close all;
clc;

% Delay Specification

delays = [10e-9, 14.33e-9, 18.66e-9];


PCtimings1 = [-1,1,38,40,103,105,168,170,220,222,272,274]*1e-9;
controlPowers1 = ones(1,length(PCtimings1)/2);
% controlPowers1(1) = 0.5;
% controlPowers1(end) = 0.5;
PCtimings2 = [43+8,93,183+8,243]*1e-9
controlPowers2 = ones(1,length(PCtimings2)/2)


PockelsObject.clearPockels();
PC1 = PockelsObject(PCtimings1,controlPowers1);
PC2 = PockelsObject(PCtimings2,controlPowers2);


% Vector of input pulse timings
num_pulses_start = 100;
timings = 0:13e-9:(num_pulses_start-1)*13e-9;

% Pulse sequence creation
Pulse.clearPulses();
inputsignal = zeros(length(timings)+100,1);

for i = 1:length(timings)
    pulse = Pulse([timings(i)]);
    inputsignal(i) = pulse.ID;
end





