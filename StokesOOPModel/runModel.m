clear;
close all;
clc;

nArray = [18,20]; %, 14, 18, 22];
TArray = [962, 2028, 2951]*10^-9;

%[260, 624, 962, 2028, 2951]*10^-9;

timeMSEMatrix = [];
powerMSEMatrix = [];
residualPowerMSEMatrix = [];

timeAbsMatrix = [];
powerAbsMatrix = [];
residualAbsMatrix = [];

for j = 1:length(nArray)
    for k = 1:length(TArray)
        % Specify a desired n and T
        n = nArray(j);
        T = TArray(k);

    % Delay Specification

        delays = [];

    % Vector of input pulse timings
        %num_pulses_start = 800;
        num_pulses_start = T/(13e-9)
        timings = 0:13e-9:(num_pulses_start-1)*13e-9;

        uddTimes =(pi/(2*n+2):pi/(2*n+2):n*pi/(2*n+2))';
        uddSequence = T*sin(uddTimes).^2;

        PCtimings1 = [];

        for i = 1:length(uddSequence)
            [nearestPulseTime, nearestPulseIndex] = min(abs(timings - uddSequence(i)));
            nearestPulseIndex;
            onTime = timings(nearestPulseIndex);
            offTime = onTime + 2*10^-9;
            PCtimings1 = [PCtimings1 onTime offTime];
        end

        controlPowers1 = ones(1,length(PCtimings1)/2);
        controlPowers1(1) = 0.5;
        controlPowers1(end) = 0.5;

        %PCtimings1

        %PCtimings1 = [-1,1,38,40,103,105,168,170,220,222,272,274]*1e-9;

        PockelsObject.clearPockels();
        PC1 = PockelsObject(PCtimings1,controlPowers1);


        % Pulse sequence creation
        Pulse.clearPulses();
        inputsignal = zeros(length(timings)+100,1);

        for i = 1:length(timings)
            pulse = Pulse([timings(i)]);
            inputsignal(i) = pulse.ID;
        end
        
        sim('PulsePickingModel.slx')
        
        timeMSEMatrix(j, k) = timeMSE;
        powerMSEMatrix(j, k) = powerMSE;
        residualPowerMSEMatrix(j, k) = residualPowerMSE;

        timeAbsMatrix(j, k) = timeAbsError;
        powerAbsMatrix(j, k) = powerAbsError;
        residualAbsMatrix(j, k) = residualAbsError;
        
    end
end