function out = minFun(x,idealTimes,repRate,compositeDelays)
% calculates a quantity for minimization via fmincon for the purpose of
% optimizing a set of digital delays
%
% All times are in nanoseconds.
%
% Inputs:
%  x - input from fmincon, containing the fractions of the repetition rate
%      at which the digital pulses will arrive, mod rep rate
%  idealTimes - the theoretically ideal pulse arrival times
%  repRate - the repetition time of the laser
%  compositeDelays - handle of function to construct the set of usable
%                    delays from the set of tunable delays
%  
%
% Outputs:
%  The function computes an error function of a non-ideal pulse sequence
%  relative to an ideal sequence for the purposes of minimization via
%  fmincon. Currently, the function is
%       error = mean-squared error + switching function error (weighted)


% relative weights of switching function to mean-squared errors
relWT = 100;

% the ideal times
modTimes = mod(idealTimes,repRate);

% construct the possible delay lines in subfunction; add preceding and
% succeeding pulses as well for wraparound boundary conditions
digTimes = repRate*compositeDelays(x);
perShift = repRate*ones(length(digTimes),1); % time of one repetition of laser
allTimes = [digTimes; digTimes+perShift; digTimes-perShift];

% here we find the nearest pulse, either in this set of digital pulses or an
% adjacent one, for each real pulse
nearPulses = dsearchn(allTimes,modTimes);

% error metric (out) is (RMS error + relWT)*SF error
errs = allTimes(nearPulses,1) - modTimes((1:length(idealTimes))',1);
out = (sqrt(errs'*errs) + relWT)*abs((-1).^(0:(length(errs)-1))*errs);
