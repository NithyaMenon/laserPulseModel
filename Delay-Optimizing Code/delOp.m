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

repRate = 13; % input pulse repetition rate, in nanoseconds


[compDels, conFun, nDelays] = experimentFile();

ff = @(w,timings) abs(1+(-1)^(n+1)*exp(1i*w*T) + ...
        sum(2*exp(1i*bsxfun(@plus,(1:n)'*pi,timings*w)),1)).^2;

if nargin<3
    plotCheck = 2;
end

idealTimes = uddTimes(T,n); % UDD sequence times
delTimes = (0:1/nDelays:(1-1/nDelays))'; % a uniformly-spaced default
minVal = minFun(delTimes,idealTimes,ff,T,repRate,compDels); % starting value
options = optimset('Algorithm','active-set','Display','off'); % suppress output

% constraint matrices that specify 0<x0<x1<x2<2
[A,B,Aeq,Beq,lb,ub] = conFun();

% get initial conditions
ICs = ICmatrix(nDelays);

% performs optimization
for ind = 1:size(ICs,2)
    delTry = fmincon(@(x)minFun(x,idealTimes,ff,T,repRate,compDels),ICs(:,ind),...
        A,B,Aeq,Beq,lb,ub,[],options);
    minTry = minFun(delTry,idealTimes,ff,T,repRate,compDels);
        
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


function out = minFun(x,idealTimes,ff,T,repRate,compositeDelays)
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
target = 17.317171337233528;
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
out = quad(@(w)ff(w,allTimes(nearPulses,1)).*lorentzian(w)./w.^2,0,target/T);
end


function ICs = ICmatrix(nDelays)
% returns a matrix of sets of initial conditions to be used in fmincon
%

ICs = rand(nDelays,1);
end


function out = lorentzian(w)
% lorentzian function with correlation time 10^6 ns
out = 10^6*2/pi./(1+(w*10^6).^2);
end


function out = uddTimes(T,n)
% constructs a vector of ideal times in a UDD pulse sequence
out = T*sin((pi/(2*n+2):pi/(2*n+2):n*pi/(2*n+2))').^2;
end