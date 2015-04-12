function [eomOnTimes, eomOffTimes, ppEomOnTimes, ppEomOffTimes, seqFail, err, ffResult] = automate(T,N,delTimes,bestDelays)
% Inputs:
%  T - the overall length of the UDD sequence to be approximated, in
%      nanoseconds
%  n - the number of pi pulses in the UDD sequence
%  delTimes - column vector of delay times, as fractions of repRate.
%             1st delay should be 0
%  bestDelays - column vector of delay corresponding to each pulse

%  example input:
%    delTimes = repRate*[0;1.3334;0.6667]; 
% note second delay time is greater than the rise time. if the supplied
% delay 2 is not greater, the repRate will be added to it automatically
%    bestDelays = [1;3;2;3;2;3;2;1];
% note delays for pi/2 pulses are included. if this is not done, it
% will be fixed automatically
%    T=2028;
%    N=6;



repRate = 13;
riseTime = 8;
idealTimes = [0; uddTimes(T,N,0); T];
offset = 0;

delTimes = delTimes.*repRate;
if delTimes(2)<riseTime
    delTimes(2) = delTimes(2)+repRate;    
end
if length(bestDelays)==N
    bestDelays = [1;bestDelays;1];
end

bestDelTimes = delTimes(bestDelays);
pulseNum = round((idealTimes-bestDelTimes)/repRate);
actualTimes = (pulseNum*repRate)+bestDelTimes;
passes = [(actualTimes-delTimes(bestDelays)), actualTimes];

%this part determines how the EOM should start out
eomOnTimes = [];
eomOffTimes = [];
temp = -1;
for i=1:length(bestDelays)
    if bestDelays(i)==1
        break
    end
    if bestDelays(i)==3
        temp = temp*-1;
        break
    end
    if bestDelays(i)==2
        temp = temp*-1;
    end
end
if temp==1
    eomOnTimes = [0];
end
if temp==-1
    eomOffTimes = [0];
end

for i=1:length(bestDelays)
    if bestDelays(i)==1;
        if temp==1
            eomOffTimes = [eomOffTimes; (passes(i,1)-10)];
            temp = -1;
        end
    end
    if bestDelays(i)==3;
        if temp==-1;
            eomOnTimes = [eomOnTimes; (passes(i,1)-10)];
            temp = 1;
        end
    end
    if bestDelays(i)==2;
        if temp==-1;
            eomOnTimes = [eomOnTimes; (passes(i,1)+1)];
        end
        if temp==1;
            eomOffTimes = [eomOffTimes; (passes(i,1)+1)];
        end
        temp = temp * -1;
    end
end

%adj = 0;
%if length(unique([pulseNum;pulseNum+1]))~=2*length(pulseNum)
%    fprintf('\nErr: Warning, adjacent pulses needed, for sequence with T=%d and N=%d.\n',T,N);
%    adj = 1;
%end

ppEomOffTimes = passes(:,1)- offset+1;
ppEomOnTimes = ppEomOffTimes - 2;

eomOnTimes = eomOnTimes + 8;

error = actualTimes-idealTimes;
%maxErr=0;
%for k = 1:length(error)
%    if abs(error(k)) > abs(maxErr)
%        maxErr = error(k);
%    end
%end
relWT=100;
err = (sqrt(sum(error.*error))/relWT + 1) * abs(sum(((-1).^([0:length(error)-1])*error)));   


n=1:N;
omegaT = logspace(-2,2,300)';
filter_function = @(timings) abs(1+(-1)^(N+1)*exp(1i*omegaT) + ...
        sum(2*exp(1i*bsxfun(@plus,n*pi,omegaT*timings)),2)).^2;
F = filter_function(actualTimes(2:end-1)'/T);
ffResult=F(1);

%autoplot(T, N, idealTimes, actualTimes, err, passes, eomOnTimes, eomOffTimes);
seqFail=0;
if length(unique(ppEomOffTimes))~=length(ppEomOffTimes) ...
        || length(unique(ppEomOnTimes))~=length(ppEomOnTimes)
    fprintf('\nErr: Multiple pulses created from one input pulse, for sequence with T=%d and N=%d.\n',T,N);
    seqFail=1;
end

