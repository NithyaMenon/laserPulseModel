function [delTimes, digTimes, bestDelays, minVal] = delOp(T,n,plotCheck)
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
if nargin<3
    plotCheck = 2;
end

repRate = 13; % input pulse repetition rate, in nanoseconds
idealTimes = uddTimes(T,n); % UDD sequence times

[compDels, conFun, nDelays] = experimentFile();

%use Pulse Picking Design if the number of delays is zero
if nDelays==0
digTimes=digitizer(idealTimes,T,repRate,1);

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
    ff = @(w,timings) abs(1+(-1)^(n+1)*exp(1i*w*T) + ...
            sum(2*bsxfun(@times,(-1).^(1:n)',exp(1i*timings*w)),1)).^2;
    
    w = logspace(-6,8,1000);
    [~,uLimInd] = max(ff(w,idealTimes)./w.^2);
    uLim = w(uLimInd);

    delTimes = (0:1/nDelays:(1-1/nDelays))'; % a uniformly-spaced default
    minVal = minFun(delTimes,idealTimes,ff,uLim,repRate,compDels); % starting value
    options = optimset('Algorithm','sqp','Display','off','UseParallel','always'); % suppress output

    % constraint matrices that specify 0<x0<x1<x2<2
    [A,B,Aeq,Beq,lb,ub] = conFun();

    % get initial conditions
    ICs = ICmatrix(n,idealTimes,repRate);

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

% compute filter function
out = quad(@(w)ff(w,allTimes(nearPulses,1)-modTimes+idealTimes).*noise(w)./w.^2*2/pi,0,uLim,1e-4);
end


function ICs = ICmatrix(n,idealTimes,repRate)
% returns a matrix of sets of initial conditions to be used in fmincon
%

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
% lorentzian function with correlation time 10^6 ns
out = 10^6*2/pi./(1+(w*10^6).^2);
end


function out = uddTimes(T,n)
% constructs a vector of ideal times in a UDD pulse sequence
out = T*sin((pi/(2*n+2):pi/(2*n+2):n*pi/(2*n+2))').^2;
end
