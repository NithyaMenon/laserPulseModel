function [pc2OnTimes, pc2OffTimes, pc1OnTimes, pc1OffTimes, delTimes, seqFail] = automate(T,N,digTimes,bestDelays)
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

% Outputs:
%  

repRate = 13;
riseTime = 8;
idealTimes = [0; uddTimes(T,N,0); T];

if mod(T,repRate)~=0
   warning('T (currently T=%d) must be a multiple of 13 ns',T); 
end

% delTimes is delay lengths in ns
delTimes = digTimes.*repRate;
delTimes=delTimes+repRate;
% bestDelays is delay length associated with each pulse
if length(bestDelays)==N
    bestDelays = [1;bestDelays;1];
end
bestDelTimes = delTimes(bestDelays);

pulseNum = round((idealTimes-bestDelTimes)/repRate);
actualTimes = (pulseNum*repRate)+bestDelTimes;
% passes is times the desired pulses pass through rotator EOM (including
% forward and reverse passes)
passes = [(actualTimes-delTimes(bestDelays)), actualTimes];
% allPasses are all times anything might pass through rotator EOM
allPasses = [(actualTimes-delTimes(bestDelays)), (actualTimes-delTimes(bestDelays))+delTimes(1),...
    (actualTimes-delTimes(bestDelays))+delTimes(2),(actualTimes-delTimes(bestDelays))+delTimes(3)];

pc2OnTimes = [];
pc2OffTimes = [];
% temp is used to track the "current" state of the rotator EOM throughout
% the code. It starts at -1, or EOM off.
temp = -1;

% This section determines whether the rotator EOM should start out on or
% off. However, in delOp we are fixing the first pulse to use delay 1,
% which means the EOM should always start off. So, unless that is changed,
% this section is unnecessary.
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
    pc2OnTimes = 0;
end

% This block determines when PC2 (the rotator EOM) should switch on and
% off, by using the information in passes. This goes in pc2OffTimes and
% pc2OnTimes.
% It also used allPasses to determine all the times when a pulse enters
% the rotator EOM, and whether the EOM should be off or on at those times.
% This goes in desiredOff and desiredOn.
desiredOn=[];
desiredOff=[];
for i=1:length(bestDelays)
    if bestDelays(i)==1;
        desiredOff = [desiredOff,allPasses(i,:)];
        if temp==1
            pc2OffTimes = [pc2OffTimes; (passes(i,1)-9)];
            temp = -1;
        end
    end
    if bestDelays(i)==3;
        desiredOn = [desiredOn,allPasses(i,:)];
        if temp==-1;
            pc2OnTimes = [pc2OnTimes; (passes(i,1)-9)];
            temp = 1;
        end
    end
    if bestDelays(i)==2;
        if temp==-1;
            pc2OnTimes = [pc2OnTimes; (passes(i,1)+1)];
            desiredOff = [desiredOff, allPasses(i,1)];
            desiredOn = [desiredOn, allPasses(i,2:end)];
        end
        if temp==1;
            pc2OffTimes = [pc2OffTimes; (passes(i,1)+1)];
            desiredOn = [desiredOn, allPasses(i,1)];
            desiredOff = [desiredOff, allPasses(i,2:end)];
        end
        temp = temp * -1;
    end
end

% Times when PC1 (pulse-picking EOM) switches on or off is determined from
% passes. Note that the times are not when the EOM begins switching; they
% are the times that the EOM is entirely on. Thus pc1OffTimes are the
% times when the EOM begins switching off, and pc1OnTimes are the times
% when the EOM finishes switching on.
pc1OffTimes = passes(:,1)+1;
pc1OnTimes = pc1OffTimes - 2;

% If desired pulses are so close together that multiple output pulses would
% have to be made from a single input pulse, this returns seqFail=1,
% meaning this sequence cannot be created.
seqFail=0;
if length(unique(pc1OffTimes))~=length(pc1OffTimes) ...
        || length(unique(pc1OnTimes))~=length(pc1OnTimes)
    warning('\nErr: Multiple pulses created from one input pulse, for sequence with T=%d and N=%d.\n',T,N);
    seqFail=1;
end

% EOM timings are put into format that runExperiment will use. Note that
% riseTime is added to pc2OnTimes, so that they match the pc1 times in
% referring to when the EOM is entirely on.
pc1OffTimes = sort(pc1OffTimes'*10^-9);
pc1OnTimes = sort(pc1OnTimes'*10^-9);
pc2OnTimes = sort((pc2OnTimes + riseTime)'*10^-9);
pc2OffTimes = sort(pc2OffTimes'*10^-9);
PCTimings2 = zeros(1,length(pc2OnTimes)+length(pc2OffTimes));
PCTimings2(1:2:end)=pc2OnTimes;
PCTimings2(2:2:end)=pc2OffTimes;
PCTimings2 = PCTimings2*1e9;

% To prevent errors if every pulse needs delay1 applied
if isempty(PCTimings2)
    return
end

% timeOn will be pairs of numbers: [1 10; 30 40; 100 120]. They are the
% times between which the rotator EOM will be on, e.g., EOM on between 1
% and 10 ns, 30 and 40 ns, and 100 and 120 ns.
if mod(length(PCTimings2),2)~=0
    timeOn = [PCTimings2(1:2:end); PCTimings2(2:2:end),PCTimings2(end)+1e-7]';
    %timeOff = [PCTimings2(2:2:end); PCTimings2(3:2:end)]';
else
    timeOn = [PCTimings2(1:2:end); PCTimings2(2:2:end)]';
    %timeOff = [PCTimings2(2:2:end); PCTimings2(3:2:end),PCTimings2(end)+1e-7]';
end

% Goes through all times when passes occur, checks if the EOM is in the
% correct state at that time. If the EOM is not in the correct state,
% returns seqFail=1 (substantial failure). If the EOM is almost in the
% correct state (within the first 5 ns of rising when it should be off, or
% within the first 1 ns of falling when it should be on), it returns
% seqFail=2 (partial failure).
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
            if j>low-1 && j<high+1
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
        low=timeOn(i,1)-riseTime;
        high=timeOn(i,2)+riseTime;
        if j>low && j<high
            success=1;
        end
    end
    if success==1
        for i=1:length(timeOn(:,1))
            low=timeOn(i,1);
            high=timeOn(i,2);
            if j>low+riseTime-3 && j<high-riseTime+3
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
