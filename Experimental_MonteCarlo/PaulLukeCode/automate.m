function [eomOnTimes, eomOffTimes, ppEomOnTimes, ppEomOffTimes, delTimes, seqFail] = automate(T,N,delTimes,bestDelays)
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

delTimes = delTimes.*repRate;
%if delTimes(2)<riseTime
%    delTimes(2) = delTimes(2)+repRate;    
%end
delTimes=delTimes+13;
if length(bestDelays)==N
    bestDelays = [1;bestDelays;1];
end

bestDelTimes = delTimes(bestDelays);
pulseNum = round((idealTimes-bestDelTimes)/repRate);
actualTimes = (pulseNum*repRate)+bestDelTimes;
passes = [(actualTimes-delTimes(bestDelays)), actualTimes];
allPasses = [(actualTimes-delTimes(bestDelays)), (actualTimes-delTimes(bestDelays))+delTimes(1),(actualTimes-delTimes(bestDelays))+delTimes(2),(actualTimes-delTimes(bestDelays))+delTimes(3)];
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
desiredOn=[];
desiredOff=[];
for i=1:length(bestDelays)
    if bestDelays(i)==1;
        desiredOff = [desiredOff,allPasses(i,:)];
        if temp==1
            eomOffTimes = [eomOffTimes; (passes(i,1)-9)];
            temp = -1;
        end
    end
    if bestDelays(i)==3;
        desiredOn = [desiredOn,allPasses(i,:)];
        if temp==-1;
            eomOnTimes = [eomOnTimes; (passes(i,1)-9)];
            temp = 1;
        end
    end
    if bestDelays(i)==2;
        if temp==-1;
            eomOnTimes = [eomOnTimes; (passes(i,1)+1)];
            desiredOff = [desiredOff, allPasses(i,1)];
            desiredOn = [desiredOn, allPasses(i,2:end)];
        end
        if temp==1;
            eomOffTimes = [eomOffTimes; (passes(i,1)+1)];
            desiredOn = [desiredOn, allPasses(i,1)];
            desiredOff = [desiredOff, allPasses(i,2:end)];
        end
        temp = temp * -1;
    end
end

ppEomOffTimes = passes(:,1)+1;
ppEomOnTimes = ppEomOffTimes - 2;

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

PCTimings2 = zeros(1,length(eomOnTimes)+length(eomOffTimes));
PCTimings2(1:2:end)=eomOnTimes;
PCTimings2(2:2:end)=eomOffTimes;
PCTimings2 = PCTimings2*1e9;


if isempty(PCTimings2)
    return
end

if mod(length(PCTimings2),2)~=0
    timeOn = [PCTimings2(1:2:end); PCTimings2(2:2:end),PCTimings2(end)+1e-7]';
    %timeOff = [PCTimings2(2:2:end); PCTimings2(3:2:end)]';
else
    timeOn = [PCTimings2(1:2:end); PCTimings2(2:2:end)]';
    %timeOff = [PCTimings2(2:2:end); PCTimings2(3:2:end),PCTimings2(end)+1e-7]';
end

timeOn
desiredOn
desiredOff

for j=desiredOn
    success = 0;
    borderline = 0;
    for i=1:length(timeOn(:,1))
        low=timeOn(i,1);
        high=timeOn(i,2);
        if j>low && j<high
            success=1;
        end
    end
    if success==0
        for i=1:length(timeOn(:,1))
            low=timeOn(i,1);
            high=timeOn(i,2);
            if j>low-8 && j<high+8
                borderline=1;
            end
        end
        if borderline==1 && seqFail~=1
	        seqFail=2;
        else
            seqFail=1;
        end
    end
end


for j=desiredOff
    success = 0;
    borderline = 0;
    for i=1:length(timeOn(:,1))
        low=timeOn(i,1)-8;
        high=timeOn(i,2)+8;
        if j>low && j<high
            success=1;
        end
    end
    if success==1
        for i=1:length(timeOn(:,1))
            low=timeOn(i,1);
            high=timeOn(i,2);
            if j>low+8 && j<high-8
                borderline=1;
            end
        end
        if borderline==0 && seqFail~=1
            seqFail=2;
        else
            seqFail=1;
        end
    end
end

%changes first EOM timings such that when adjacent pulses are
%picked, EOM just stays on for that time
%if length(unique([pulseNum;pulseNum+1]))~=2*length(pulseNum)
%    warning('\nWarning, adjacent pulses needed, for sequence with T=%d and N=%d.\n',T,N);
%    for i=length(ppEomOnTimes):-1:2
%        if abs(ppEomOnTimes(i)-(ppEomOnTimes(i-1)+13*10^-9))<10^-15
%            ppEomOnTimes(i)=[];
%            ppEomOffTimes(i-1)=[];
%        end 
%    end
%end


