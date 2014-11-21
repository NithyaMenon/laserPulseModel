function [msd, absolute] = errorCalc(Tmin,Tmax,n,plotCheck)
% computes mean-square-displacement and absolute-error data for
% optimized delay options across [Tmin, Tmax] and for order n
%
% Inputs:
%  Tmin - the minimum length of the UDD sequence, in nanoseconds
%  Tmax - the maximum length of the UDD sequence, in nanoseconds
%  n - the order of the UDD sequence
%  plotCheck - boolean to indicate whether or not to plot results
%
% Outputs:
%  For each value of T between Tmin and Tmax (that is an increment of 13),
%  errorBase computes the total mean-square displacemnt of the digitized
%  times from the ideal times, output in "msd." It also computes the
%  average absolute error, output in "absolute." Both msd vs T and absolute
%  vs T can be plotted by setting plotCheck = 1.
tic
if nargin<4
    plotCheck = true;
end

repRate = 13; % nanoseconds

Tmin = Tmin - mod(Tmin,repRate);
T = (Tmin:repRate:Tmax)';
[msd, absolute] = deal(zeros(length(T),1));

for i = 1:length(T)
    idealTimes = uddTimes(T(i),n,0);
    delTimes = delayOptz3(T(i),n,0);
    msd(i) = pulseMSD3(delTimes,idealTimes,repRate);
    absolute(i) = pulseAVG3(delTimes,idealTimes,repRate);
end

if plotCheck
    fixfonts = @(h) set(h,'FontName','Arial',...
                      'FontSize',10,...
                      'FontWeight','bold');
                  
    plot([T T],[msd absolute],'LineWidth',2);
    ylim([0 13/12]);
    fixfonts(xlabel('UDD Sequence Length, T'));
    fixfonts(ylabel('Size of error (ns or ns^2)'));
    fixfonts(title(strcat('Error of Optimized Delay Spacing, for Order n=',int2str(n))));
    fixfonts(gca);
    fixfonts(legend('MSD','Avg. Abs. Val.'));
end
t=toc
