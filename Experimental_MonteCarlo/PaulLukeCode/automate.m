function [eomOnTimes, eomOffTimes, ppEomOnTimes, ppEomOffTimes, seqFail] = automate(T,N,delTimes,bestDelays)
% Inputs:
%  T - the overall length of the UDD sequence to be approximated, in
%      nanoseconds
%  n - the number of pi pulses in the UDD sequence
%  delTimes - column vector of delay times, as fractions of repRate.
%             1st delay should be 0
%  bestDelays - column vector of delay corresponding to each pulse

%  example input:
%    delTimes = 13*[0;1.3334;0.6667]; 
% note second delay time is greater than the rise time. if the supplied
% delay 2 is not greater, the repRate will be added to it automatically
%    bestDelays = [1;3;2;3;2;3;2;1];
% note delays for pi/2 pulses are included. if this is not done, it
% will be fixed automatically
%    T=2028;
%    N=6;

if mod(T,13)~=0
   warning('T (currently T=%d) must be a multiple of 13 ns',T); 
end

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
%commented out to make output work with MC_run
%if temp==-1
%    eomOffTimes = [0];
%end

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

ppEomOffTimes = passes(:,1)- offset+1;
ppEomOnTimes = ppEomOffTimes - 2;

error = actualTimes-idealTimes;


seqFail=0;
if length(unique(ppEomOffTimes))~=length(ppEomOffTimes) ...
        || length(unique(ppEomOnTimes))~=length(ppEomOnTimes)
    warning('\nErr: Multiple pulses created from one input pulse, for sequence with T=%d and N=%d.\n',T,N);
    seqFail=1;
end


ppEomOffTimes = sort(ppEomOffTimes'*10^-9);
ppEomOnTimes = sort(ppEomOnTimes'*10^-9);
eomOnTimes = sort((eomOnTimes + 8)'*10^-9);
eomOffTimes = sort(eomOffTimes'*10^-9);

%changes first EOM timings such that when adjacent pulses are
%picked, EOM just stays on for that time
if length(unique([pulseNum;pulseNum+1]))~=2*length(pulseNum)
    warning('\nWarning, adjacent pulses needed, for sequence with T=%d and N=%d.\n',T,N);
    for i=length(ppEomOnTimes):-1:2
        if abs(ppEomOnTimes(i)-(ppEomOnTimes(i-1)+13*10^-9))<10^-15
            ppEomOnTimes(i)=[];
            ppEomOffTimes(i-1)=[];
        end 
    end
end


