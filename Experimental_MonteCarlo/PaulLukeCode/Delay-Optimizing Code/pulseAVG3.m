function out = pulseAVG3(x,idealTimes,repRate)
% calculates the average absolute displacement of digitized pulses from ideal
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
%  The function computes the average of the absolute value time differences between
%  each ideal pulse and its nearest digital pulse.

out = 0;

modTimes = mod(idealTimes,repRate);

digTimes = repRate*compositeDelays(x);
perShift = repRate*ones(length(digTimes),1); % time of one repetition of laser
allTimes = [digTimes; digTimes+perShift; digTimes-perShift];

% here we find the nearest pulse, either in this set of digital pulses or an
% adjacent one, for each real pulse
nearPulses = dsearchn(allTimes,modTimes);

for i = 1:length(idealTimes)
    out = out + abs(allTimes(nearPulses(i),1)-modTimes(i,1));
end

out = out/length(idealTimes);
