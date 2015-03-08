function [actualT, idealTimes, actualTimes, err, passes, eomOnTimes, eomOffTimes] = automate(T,N)
% Inputs:
%  T - the overall length of the UDD sequence to be approximated, in
%      nanoseconds
%  n - the number of pi pulses in the UDD sequence




%call delay optimization stuff
repRate = 13;
actualT = 299;
idealTimes = [0; uddTimes(T,N,0); actualT];
delTimes = 13+[0;(repRate/3);(2*repRate/3)];
bestDelays = [1;1;2;1;1;3;1;1];




offset = min(delTimes-10);
actualDelTimes = delTimes - offset;

bestDelTimes = delTimes(bestDelays);
pulseNum = round((idealTimes-bestDelTimes)/repRate);
actualTimes = (pulseNum*repRate)+bestDelTimes;
err = actualTimes-idealTimes;
passes = [(actualTimes-actualDelTimes(bestDelays)), actualTimes];

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


%error = actualTimes-idealTimes;
%maxErr=0;
%for k = 1:length(error)
%    if abs(error(k)) > abs(maxErr)
%        maxErr = error(k);
%    end
%end


%msd = sum(error.^2);
