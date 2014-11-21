function [delTimes, digTimes, bestDelays, msd] = delayOptz3(T,n,plotCheck)
% finds the optimal delays for an optical network with eight digital delays
% (constructed from three tunable delays) for a UDD sequence of length T
% and order n
%
% Inputs:
%  T - the overall length of the UDD sequence to be approximated, in
%      nanoseconds
%  n - the number of pi pulses in the UDD sequence
%  plot - optional boolean input to turn off plotting
%
% Outputs:
%  The function computes a vector of the optimal times (mod 13 nanoseconds)
%  at which the digitized pulses should arrive so as to minimize the
%  mean-square time difference between pulses. To do the optimization, the
%  code employs fmincon, and tries a number of initial conditions to
%  improve the chances of finding a global minimum.
%
% Required files:
%  uddTimes.m
%  pulseMSD3.m

if nargin<3
    plotCheck = true;
end

repRate = 13; % input pulse repetition rate, in nanoseconds
stepSize = 0.25; % size (as fraction of repRate) of steps for optimization

idealTimes = uddTimes(T,n,0); % UDD sequence times
msd = Inf; % starting value
delTimes = [0; 1/6; 1/3; 1/2]; % a uniformly-spaced default
options = optimset('Algorithm','active-set','Display','off'); % suppress output

% constraint matrices that specify 0<x0<1, 0<x1<x2<x3<2
A = [0 1 -1 0; 0 0 1 -1];
b = [0; 0];

% performs nested for-loop to try all sorts of initial conditions
for x0 = 0:stepSize:1
    for x3 = 0:stepSize:1
        for x2 = 0:stepSize:x3-stepSize
            for x1 = 0:stepSize/2:x2-stepSize/2
                delTry = fmincon(@(x)pulseMSD3(x,idealTimes,repRate),[x0;x1;x2;x3],...
                    A,b,[],[],zeros(4,1),[1; 2*ones(3,1)],[],options);
                msdTry = pulseMSD3(delTry,idealTimes,repRate);
                
                if msdTry < msd % we've done better!
                    msd = msdTry;
                    delTimes = delTry;
                end
            end
        end
    end
end

% the list of all delays constructed from the optimized delays; offset
%  added at the end
digTimes = compositeDelays(delTimes);

% plotting
if plotCheck
    fixfonts = @(h) set(h,'FontName','Arial',...
                      'FontSize',10,...
                      'FontWeight','bold');
    figure
    hold on
    xlim([0 14])
    ylim([0 n+1])
    fixfonts(xlabel('Pulse Arrival Time mod Repetition Rate, in ns'));
    fixfonts(ylabel('\pi Pulse Number'));
    fixfonts(title(strcat('Optimized Pulse Delay Lines for T=',int2str(T),...
        ' and n=',int2str(n))));
    fixfonts(gca);

    % markers for ideal times
    plot(mod(idealTimes,repRate),(1:n)','o')

    % lines for digital delays
    for j = 1:length(digTimes)
        plot(repRate*mod(digTimes(j),1)*[1 1],[0 n+1],...
            'Color','red',...
            'LineWidth',2)
    end
    
    fixfonts(legend('Ideal Pulses','Delay Lines'));

    hold off
end

% matches each pulse to the closest delay line
bestDelays = dsearchn(repRate*mod(digTimes,1),mod(idealTimes,repRate));
