% laser pulse vector: 
%   [frequency(Hz), amplitude(?), offset(ns), polarization(0:vertical or 1:horizontal), power(fraction)]

inputPulse = [370*10^12, 1, 0, 0, 1];
stage1 = wireModule(inputPulse, 1);
[transmit, reflected] = beamSplitterModule(stage1, .5);
stage3 = wireModule(transmit, .5);
