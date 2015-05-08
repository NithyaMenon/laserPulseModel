function [msd, absolute] = errorWorst(Tmin,Tmax,n,plotCheck)
% computes mean-square-displacement and absolute-error data for
% only choosing the closest input pulse, with no modifications
%
% Inputs:
%  Tmin - the minimum length of the UDD sequence, in nanoseconds
%  Tmax - the maximum length of the UDD sequence, in nanoseconds
%  n - the order of the UDD sequence
%  plotCheck - boolean to indicate whether or not to plot results
%
% Outputs:
%  For each value of T between Tmin and Tmax (that is an increment of 13),
%  errorBase computes the total mean-square displacemnt of the pulse-picked
%  times from the ideal times, output in "msd." It also computes the
%  average absolute error, output in "absolute." Both msd vs T and absolute
%  vs T can be plotted by setting plotCheck = 1.

if nargin<4
    plotCheck = true;
end

repRate = 13; % nanoseconds

Tmin = Tmin - mod(Tmin,repRate);
T = (Tmin:repRate:Tmax)';
[msd, absolute] = deal(zeros(length(T),1));

for i = 1:length(T)
    idealTimes = uddTimes(T(i),n,0);
    digTimes = digitizer(idealTimes,T(i),repRate,1);
    diffs = abs(digTimes - idealTimes);
    absolute(i) = sum(diffs)/n;
    msd(i) = sum(diffs.^2)/n;
end

if plotCheck
    figure
    fixfonts = @(h) set(h,'FontName','Arial',...
                      'FontSize',10,...
                      'FontWeight','bold');
                  
    plot([T T],[msd absolute],'LineWidth',2);
    fixfonts(xlabel('UDD Sequence Length, T'));
    fixfonts(ylabel('Size of error (ns or ns^2)'));
    fixfonts(title(strcat('Error of Uniform Delay Spacing, for Order n=',int2str(n))));
    fixfonts(gca);
    fixfonts(legend('MSD','Avg. Abs. Val.'));
end
