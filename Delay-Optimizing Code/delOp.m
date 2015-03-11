function [delTimes, digTimes, bestDelays, msd] = delOp(T,n,plotCheck)
% finds the optimal delays for an optical network with digital delay
% options for a UDD sequence of length T and order n
%
% Inputs:
%  T - the overall length of the UDD sequence to be approximated, in
%      nanoseconds
%  n - the number of pi pulses in the UDD sequence
%  plotCheck - optional boolean input to turn off plotting
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


compDels = @compositeDelays3b;
conFun = @constraintFunction;

if nargin<3
    plotCheck = true;
end

repRate = 13; % input pulse repetition rate, in nanoseconds
stepSize = 0.25; % size (as fraction of repRate) of steps for optimization

idealTimes = uddTimes(T,n,0); % UDD sequence times
msd = Inf; % starting value
delTimes = [1/3; 2/3]; % a uniformly-spaced default
options = optimset('Algorithm','active-set','Display','off'); % suppress output

% constraint matrices that specify 0<x0<x1<x2<2
A = [1 -1];
b = [0];

% performs nested for-loop to try all sorts of initial conditions
for x1 = 0:stepSize:1
    for x0 = 0:stepSize/2:1
        delTry = fmincon(@(x)minFun(x,idealTimes,repRate,compDels),[x0;x1],...
            A,b,[],[],zeros(2,1),ones(2,1),[],options);
        msdTry = minFun(delTry,idealTimes,repRate,compDels);
            
        if msdTry < msd % we've done better!
            msd = msdTry;
            delTimes = delTry;
        end
    end
end

% the list of all delays constructed from the optimized delays; offset
%  added at the end
digTimes = compDels(delTimes);

% matches each pulse to the closest delay line
bestDelays = dsearchn(repRate*mod(digTimes,1),mod(idealTimes,repRate));


% plotting
if plotCheck == 1
    fixfonts = @(h) set(h,'FontName','Arial',...
                      'FontSize',10,...
                      'FontWeight','bold');
    figure
    hold on
    fixfonts(xlabel('\pi Pulse Number'));
    fixfonts(ylabel('Pulse Arrival Time Error, ns'));
    fixfonts(title(strcat('Pulse Error Comparison for Optimized and Evenly-Spaced Delays',...
        ', T=',int2str(T),', n=',int2str(n))));
    fixfonts(gca);
    
    % error from uniform delays
    uniTimes = digitizer(idealTimes,T,repRate,6);
    uniErrs = uniTimes - idealTimes;
    
    % error from optimized delays
    digModTimes = [digTimes+ones(size(digTimes,1),1); digTimes;...
        digTimes-ones(size(digTimes,1),1)];
    bestModDelays = dsearchn(repRate*digModTimes,mod(idealTimes,repRate));
    digErrs = repRate*digModTimes(bestModDelays) - mod(idealTimes,repRate);
    plot((1:n)',uniErrs,(1:n)',digErrs,'LineWidth',2)
    
    ymax = max(abs(ylim(gca)));
    ylim([-ymax ymax]);
    legend('Evenly-Spaced Delays','Optimized Delays');
elseif plotCheck == 2
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

