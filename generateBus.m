% Create bus object for the following struct
% time: [24001 x 1] 
% data: [24001 x 1] 
% pol: 0 or 1

inputPulse = inputSequence ( 76*10^6, 1, 0, 0, 300*10^-9);

[nrow, ncol] = size(inputPulse.data);

zeroMatrix = zeros(nrow,1);
X = struct('time',zeroMatrix,'data',zeroMatrix, 'pol', 0);
bus = Simulink.Bus.createObject(X);
