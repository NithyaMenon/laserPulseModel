function [delTimes, digTimes, bestDelays, minVal] = delOp(T,n,plotCheck)
% finds the optimal delays for an optical network with digital delay
% options for a UDD sequence of length T and order n
%
% Inputs:
%  T - the overall length of the UDD sequence to be approximated, in
%      nanoseconds
%  n - the number of pi pulses in the UDD sequence
%  plotCheck - optional integer input that selects plotting routines
%
% Outputs:
%  The function sets up and uses fmincon to determine the best set of
%  delays to use in the optical network. It is structured to handle any
%  number of delays (specified in the contents of experimentFile.m) and a
%  variety of relationships between those delays. If the number of delays
%  is zero, delOp will revert to simple pulse-picking. The function does
%  not currently check that the design can actually create the sequence -
%  it simply finds the best delays assuming all sequences can be created.
%  This may be a point of improvement in the future.
%
%       delTimes - a vector specifying the lengths of the independent delay
%                  paths, as fractions of the laser repetition rate
%       digTimes - a vector of the composite delay values, in nanoseconds
%       bestDelays - an n-by-1 vector of integers, where the jth value is
%                    the index into digTimes for which composite delay is
%                    taken by the jth pulse
%       minVal - the minimum value of the minimization function, as
%                computed by fmincon
%
% Required files:
%  experimentFile.m or replace the code in line 27 with a similar file
%
% Last updated 5/2/15 by Paul Jerger


if nargin<3
    plotCheck = 2;
end

repRate = 13;               % input pulse repetition rate, in nanoseconds
idealTimes = uddTimes(T,n); % perfect UDD sequence times

[compDels, conFun, nDelays] = experimentFile(); % obtain experiment-specific information

%use Pulse Picking Design if the number of delays is zero
if nDelays==0
    digTimes=digitizer(idealTimes,T,repRate,1); % all the work

    if plotCheck==2
     fixfonts = @(h) set(h,'FontName','Arial',...
                          'FontSize',10,...
                          'FontWeight','bold');
        figure
        hold on
        xlim([0 T])
        ylim([0 n+1])
        fixfonts(xlabel('Pulse Arrival Time, in ns'));
        fixfonts(ylabel('\pi Pulse Number'));
        fixfonts(title(strcat('Pulse Picking Times for T=',int2str(T),...
            ' and n=',int2str(n))));
        fixfonts(gca);

        % markers for ideal times
        plot(idealTimes,(1:n)','o')

        % lines for pulse picking times
        for j = 1:length(digTimes)
            plot(digTimes(j)*[1 1],[0 n+1],...
                'Color','red',...
                'LineWidth',2)
        end

        fixfonts(legend('Ideal Pulses','Picked Pulses'));

        hold off
    end

%otherwise attempt delay optimization
else
    % define the filter function as a function of frequency and pulse times   
    ff = @(w,timings) abs(1+(-1)^(n+1)*exp(1i*w*T) + ...
            sum(2*bsxfun(@times,(-1).^(1:n)',exp(1i*timings*w)),1)).^2;
    
    % in the next three lines, we find the upper limit of the overlap
    %  integral
    w = logspace(-6,8,1000);
    [~,uLimInd] = max(ff(w,idealTimes)./w.^2);
    uLim = w(uLimInd);

    delTimes = zeros(nDelays,1);                                   % pulse-picking default
    minVal = minFun(delTimes,idealTimes,ff,uLim,repRate,compDels); % starting value
    options = optimset('Algorithm','sqp','Display','off','UseParallel','always'); % suppress output

    [A,B,Aeq,Beq,lb,ub] = conFun();         % get fmincon constraints
    ICs = ICmatrix(n,idealTimes,repRate);   % get fmincon initial values

    % performs optimization
    for ind = 1:size(ICs,2)
        [delTry,minTry] = fmincon(@(x)minFun(x,idealTimes,ff,uLim,repRate,compDels),ICs(:,ind),...
            A,B,Aeq,Beq,lb,ub,[],options);

        if minTry < minVal % we've improved!
            minVal = minTry;
            delTimes = delTry;
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
end
end


function out = minFun(x,idealTimes,ff,uLim,repRate,compositeDelays)
% calculates a quantity for minimization via fmincon for the purpose of
% optimizing a set of digital delays
%
% All times are in nanoseconds.
%
% Inputs:
%  x - input from fmincon, containing the lengths of the delay paths, as
%      fractions of repRate
%  idealTimes - the theoretically ideal pulse arrival times
%  ff - function handle for the filter function
%  T - length of the entire UDD sequence
%  repRate - the repetition time of the laser
%  compositeDelays - handle of function to construct the set of composite
%                    delays from the set of delay paths
%  
%
% Outputs:
%  The function computes an error function of a non-ideal pulse sequence
%  relative to an ideal sequence for the purposes of minimization via
%  fmincon. Currently, the function is the integral of the filter function
%  times a noise power spectral density and integrated to an upper limit
%  that was computed in the main delOp function.


% the ideal times
modTimes = mod(idealTimes,repRate);

% construct the possible delay lines in subfunction; add preceding and
%  succeeding pulses as well for wraparound boundary conditions
digTimes = repRate*compositeDelays(x);
allTimes = [digTimes; digTimes+repRate; digTimes-repRate];

nearPulses = dsearchn(allTimes,modTimes); % find nearest pulses to composite delays

% compute overlap integral
out = quad(@(w)ff(w,modTimes-allTimes(nearPulses,1)+idealTimes).*noise(w)./w.^2*2/pi,0,uLim,1e-4);
end


function ICs = ICmatrix(n,idealTimes,repRate)
% returns a matrix of sets of initial values to be used in fmincon
%
% Inputs:
%  n - the number of pi pulses in the UDD sequence
%  idealTimes - the theoretically ideal pulse arrival times
%  repRate - the repetition time of the laser
%
% Outputs:
%  Here, the initial values are just specified for two delays and are
%  basically pulled out of thin air - the idea was simply to have some
%  semblance of uniformly-spaced guesses. This feature needs to be revamped
%  in the future to make it more general; suggestions include guessing at
%  sequence pulse times or only guessing uniformly-spaced.

ICs = [0.1 0.1 0.3 0.1 0.3 0.5 0.1 0.3 0.5 0.7; ...
       0.2 0.4 0.4 0.6 0.6 0.6 0.8 0.8 0.8 0.8];
%modTimes = sort(mod(idealTimes,repRate));
%ICs = modTimes([floor(n/3);ceil(n*2/3)])/repRate;
end

function tp = digitizer(pulses,Tmax,repRate,frac)
% adjusts a series of pulse timings, 'pulses', to the nearest repRate/frac,
% where repRate is a repeated pulse rate and frac is some fraction of that
% rate

digs = (0:repRate/frac:Tmax)';
inds = dsearchn(digs,pulses);
tp = zeros(length(pulses),1);

for j = 1:length(pulses)
    tp(j) = digs(inds(j));
end
end

function out = noise(w)
% function for noise power spectral density
%
% Inputs:
%  w - frequency
%
% Outputs:
%  This function is only called by the numerical integrator. It contains
%  the information on the noise power spectral density. Currently, this is
%  modeled as a lorentzian function with a correlation time of 10 ms (times
%  are in nanoseconds in this file, so 10^6 is 10 ms). The correlation time
%  can be adjusted with the constant below, or the whole function can be
%  redone if better information becomes available.
    

    corr = 10^6; % correlation time in nanoseconds
    out = corr*2/pi./(1+(w*corr).^2);
end


function out = uddTimes(T,n)
% constructs a vector of ideal times in a UDD pulse sequence
%
% Inputs:
%  T - the overall length of the UDD sequence to be approximated, in
%      nanoseconds
%  n - the number of pi pulses in the UDD sequence
%
% Outputs:
%  Returns a vector of times representing ideal pi pulse arrival times for
%  a UDD sequence of order n and sequence length T. Times are in
%  nanoseconds.


    out = T*sin((pi/(2*n+2):pi/(2*n+2):n*pi/(2*n+2))').^2;
end
