function [eomOnTimes, eomOffTimes, delTimes] = automate_sp(T,N)
% Inputs:
%  T - the overall length of the UDD sequence to be approximated, in
%      nanoseconds
%  n - the number of pi pulses in the UDD sequence

%  example input:
%    T=2028;
%    N=6;

repRate = 13;
riseTime = 8;

idealTimes = [0; uddTimes(T,N,0); T];

delTimes = zeros(1,N/2+1);
for i = 1:N/2
    delTimes(i)=idealTimes(i+1)-idealTimes(i);
end

eomOnTimes=0;
eomOffTimes=2;
delTimes(end)=idealTimes(N/2+2);



