function [ timeAbsError, powerAbsError, residualAbsError, timeMSE, powerMSE, residualPowerMSE] = analyzePulseTrain( IDs, T, n )
% analyzePulseTrain
% Quick Script to pull out error in timings and power of a given pulse 
% sequence compared to the ideal pulse train
%
% INPUTS
%     IDs - pulse IDs of output pulse train
%     T - total length of sequence in seconds
%     n - number of desired pulses
% OUTPUTS
%     timeError - array of timing errors relative to ideal sequence
%     powerError - array of squared power error relative to the pulse closest to 
%                  the mean power of the output pulse sequence

% Compute ideal sequence for reference

idealOutput = idealPulse(T,n,1,0);
idealData = Pulse.getPulse(idealOutput);
idealTimes = [idealData.time];

% Pull out the pulses greater than 10^-5
% Probably need to come up with a better filtering criteria!! 
data = Pulse.getPulse(IDs);
data = data([data.I] > 10^-5);

residualData = Pulse.getPulse(IDs);
residualData = residualData([residualData.I] < 10^-5);

power = [data.I];
times = [data.time];

residualPower = [residualData.I];

% Compute the error relative to the ideal times
% Note that negative values correspond to an ideal time before the actual
% pulse, and a positive value corresponds to an ideal time after the actual
% pulse
%idealTimes
%times

%THIS WILL ONLY WORK IF IDEALTIMES AND TIMES HAVE THE SAME DIMENSIONS
timeError = (idealTimes - times);
timeErrorSquare = (idealTimes - times).^2;
avgPower = mean(power);
squaredError = (power - avgPower).^2;
[minError, minIndex] = min(squaredError);
powerError = (power - power(minIndex));
powerErrorSquare = (power - power(minIndex)).^2;
powerMSE = sum(powerErrorSquare)/size(powerErrorSquare,2);
timeMSE = sum(timeErrorSquare)/size(timeErrorSquare,2);

residualPowerError = (residualPower);
residualPowerErrorSquare = (residualPower).^2;
residualPowerMSE = sum(residualPowerErrorSquare)/size(powerErrorSquare,2);

timeAbsError = sum(timeError);
powerAbsError = sum(powerError);
residualAbsError = sum(residualPowerError);

end

