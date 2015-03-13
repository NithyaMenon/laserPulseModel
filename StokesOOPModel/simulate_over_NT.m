clear
clc
close all

pat = fileparts(pwd());
addpath(strcat(pat,'/StokesOOPModel/Graphing'),strcat(pat,'/StokesOOPModel/Components'));

load('digitizing_parameters.mat');

Outputs = [];

reprate = 13e-9;

for i = 1:1 % length(Params)
    prm = Params(i);
    
    N = prm.N;
    T = prm.T;
    
    delays = prm.delTimes*reprate;
    
    PC1on = (prm.PC1on + 8)*1e-9;
    PC1off = prm.PC1off*1e-9;
    PCtimings1 = [];
    for j = 1:length(PC1on)
        PCtimings1(2*j-1) = PC1on(j);
        PCtimings1(2*j) = PC1off(j);
    end
    
    PC2on = (prm.PC2on + 8)*1e-9;
    PC2off = prm.PC2off(2:end)*1e-9;
    PCtimings2 = [];
    for j = 1:length(PC2on)
        PCtimings2(2*j-1) = PC2on(j);
        PCtimings2(2*j) = PC2off(j);
    end
    


    controlPowers1 = ones(1,length(PCtimings1)/2);
    controlPowers1(1) = 0.5;
    controlPowers1(end) = 0.5;
    controlPowers2 = ones(1,length(PCtimings2)/2);


    PockelsObject.clearPockels();
    PC1 = PockelsObject(PCtimings1,controlPowers1);
    PC2 = PockelsObject(PCtimings2,controlPowers2);


    % Vector of input pulse timings
    num_pulses_start = round(T/13)+10;
    timings = 0:13e-9:(num_pulses_start-1)*13e-9;

    % Pulse sequence creation
    Pulse.clearPulses();
    inputsignal = zeros(length(timings)+100,1);

    for k = 1:length(timings)
        pulse = Pulse([timings(k)]);
%         display(pulse)
        inputsignal(k) = pulse.ID;
    end
    
    sim('New_SPD_For_Test',200);
    [ times,I,Q,U,V,widths,IDs,StateHistoryArrays ] = IDtoPulseData( simout );
    n = N;
    [timeAbsError, powerAbsError, residualAbsError, timeMSE, powerMSE, residualPowerMSE] = analyzePulseTrain(IDs, T*1e-9, n+2);

    
    Outputs(i).N = N;
    Outputs(i).T = T;
    Outputs(i).powerAbsError = powerAbsError;
    Outputs(i).powerMSE = powerMSE;
    Outputs(i).timeAbsError = timeAbsError;
    Outputs(i).timeMSE = timeMSE;
    
    
    
end