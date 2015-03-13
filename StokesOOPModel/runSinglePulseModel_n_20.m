clear;
close all;
clc;

addpath('./Graphing','./Components');

nArray = [20]; % Do NOT change -- specific to slx file
TArray = 299:130:2899; 
TArray = TArray*10^-9;

%nArray = [6, 8];
%TArray = (299+2*130)*10^-9;

%[260, 624, 962, 2028, 2951]*10^-9;

timeMSEMatrix = [];
powerMSEMatrix = [];
residualPowerMSEMatrix = [];

timeAbsMatrix = [];
powerAbsMatrix = [];
residualAbsMatrix = [];

for row = 1:length(nArray)
    for col = 1:length(TArray)
        % Specify a desired n and T
        n = nArray(row);
        T = TArray(col);
        
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
    
        sim('SinglePulseModel_n_20.slx')
        
%         timeMSEMatrix(row, col) = timeMSE;
%         powerMSEMatrix(row, col) = powerMSE;
%         residualPowerMSEMatrix(row, col) = residualPowerMSE;
% 
%         timeAbsMatrix(row, col) = timeAbsError;
%         powerAbsMatrix(row, col) = powerAbsError;
%         residualAbsMatrix(row, col) = residualAbsError;
       
    end
end