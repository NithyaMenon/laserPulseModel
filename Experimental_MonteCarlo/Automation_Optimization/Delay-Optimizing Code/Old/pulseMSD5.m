function out = pulseMSD5(x,idealTimes,repRate)
% calculates the mean square displacement of digitized pulses from ideal
% pulses, 'idealTimes,' mod the laser repetition rate, 'repRate'
%
% All times are in nanoseconds.
%
% Inputs:
%  x - input from fmincon, containing the fractions of the repetition rate
%      at which the digital pulses will arrive, mod rep rate
%  idealTimes - the theoretically ideal pulse arrival times
%  repRate - the repetition time of the laser
%
% Outputs:
%  The function computes the sum of the squared time differences between
%  each ideal pulse and its nearest digital pulse. This function is
%  intended to be used as the input for a call to fmincon, which will
%  optimize the choice of digital arrival times.

out = 0;

modTimes = mod(idealTimes,repRate);

% construct the possible delay lines in subfunction; add preceding and
% succeeding pulses as well for wraparound boundary conditions
digTimes = repRate*compositeDelays5(x);
perShift = repRate*ones(length(digTimes),1); % time of one repetition of laser
allTimes = [digTimes; digTimes+perShift; digTimes-perShift];

% here we find the nearest pulse, either in this set of digital pulses or an
% adjacent one, for each real pulse
nearPulses = dsearchn(allTimes,modTimes);

% sum individual MSDs
for i = 1:length(idealTimes)
    out = out + (allTimes(nearPulses(i),1)-modTimes(i,1))^2;
end

out = out/length(idealTimes);
