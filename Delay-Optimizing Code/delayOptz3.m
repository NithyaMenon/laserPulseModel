function [delTimes, digTimes, bestDelays, msd] = delayOptz3(T,n)
% finds the optimal delays for an optical network with eight digital delays
% (constructed from three tunable delays) for a UDD sequence of length T
% and order n
%
% Inputs:
%  T - the overall length of the UDD sequence to be approximated, in
%      nanoseconds
%  n - the number of pi pulses in the UDD sequence
%
% Outputs:
%  The function computes a vector of the optimal times (mod 13 nanoseconds)
%  at which the digitized pulses should arrive so as to minimize the
%  mean-square time difference between pulses.

repRate = 13;
stepSize = 0.1;

idealTimes = uddTimes(T,n,0);
msd = Inf;
delTimes = [0; 0.125; 0.25; 0.5];
options = optimset('Algorithm','active-set','Display','off');

% constraint matrices that specify 0<x0<1, 0<x1<x2<x3<2
A = [0 1 -1 0; 0 0 1 -1];
b = [0; 0];

for x0 = 0:stepSize:1
    for x3 = 0:stepSize:1
        for x2 = 0:stepSize:x3
            for x1 = 0:stepSize:x2
                delTry = fmincon(@(x)pulseMSD3(x,idealTimes,repRate),[x0;x1;x2;x3],...
                    A,b,[],[],zeros(4,1),[1; 2*ones(3,1)],[],options);
                msdTry = pulseMSD3(delTry,idealTimes,repRate);
                if msdTry < msd
                    msd = msdTry;
                    delTimes = delTry;
                end
            end
        end
    end
end

digTimes = [0; delTimes(2); delTimes(3); delTimes(2)+delTimes(3); ...
    delTimes(4); delTimes(2)+delTimes(4); delTimes(3)+delTimes(4); ...
    delTimes(2)+delTimes(3)+delTimes(4)] + delTimes(1)*ones(8,1);

figure
hold on
xlim([0 14])
xlabel('Pulse Arrival Time mod Repetition Rate, in ns')

for i = 1:n
    plot(mod(idealTimes(i),repRate)*[1 1], [0 1])
end

for j = 1:8
    plot(repRate*mod(digTimes(j),1)*[1 1],[0 1],'LineStyle','--','color','red')
end

hold off

bestDelays = dsearchn(repRate*mod(digTimes,1),mod(idealTimes,repRate));
