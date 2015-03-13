function [ timeAbsError, powerAbsError, residualAbsError, timeMSE, powerSSE, residualPowerSSE, ffResult] = analyzePulseTrain( IDs, T, n )
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
pwr = -6;
while(1)
    alldata = Pulse.getPulse(IDs);
    data = alldata([alldata.I] > 10^pwr);
    residualData = alldata([alldata.I] < 10^-5);
    power = [data.I];
    times = [data.time];
    residualPower = [residualData.I];
    if(length(times) == length(idealTimes))
        break;
    elseif(length(times) < length(idealTimes))
        pwr = pwr-0.5;
    else
        pwr = pwr+0.5;
    end
            
end
    


% Compute the error relative to the ideal times
% Note that negative values correspond to an ideal time before the actual
% pulse, and a positive value corresponds to an ideal time after the actual
% pulse
%idealTimes
%times

%THIS WILL ONLY WORK IF IDEALTIMES AND TIMES HAVE THE SAME DIMENSIONS
idealTimes
times
timeError = (idealTimes - times);
timeErrorSquare = (idealTimes - times).^2;
avgPower = mean(power);
squaredError = (power - avgPower).^2;
[minError, minIndex] = min(squaredError);
powerError = (power - power(minIndex));
powerErrorSquare = (power - power(minIndex)).^2;
powerSSE = sum(powerErrorSquare);
timeMSE = sum(timeErrorSquare)/size(timeErrorSquare,2);

residualPowerError = (residualPower);
residualPowerErrorSquare = (residualPower).^2;
residualPowerSSE = sum(residualPowerErrorSquare);

timeAbsError = sum(timeError);
powerAbsError = sum(powerError);
residualAbsError = sum(residualPowerError);

n=n-2;
nn=1:n
omegaT = logspace(-2,2,300)'
filter_function = @(timings) abs(1+(-1)^(n+1)*exp(1i*omegaT) + sum(2*exp(1i*bsxfun(@plus,nn*pi,omegaT*timings)),2)).^2;
F = filter_function(times(2:end-1)'/T)
ffResult=F(1);

end

