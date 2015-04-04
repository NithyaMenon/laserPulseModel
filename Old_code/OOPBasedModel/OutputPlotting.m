clc
close all

[ times,verticalPowers,horizontalPowers,widths ] = IDtoPulseData( simout );
zeropad = zeros(size(times));
timevec = [ times-widths/2-eps, times-widths/2, times+widths/2,times+widths/2+eps];
vertvec = [ zeropad, verticalPowers, verticalPowers, zeropad];
horzvec = [ zeropad, horizontalPowers, horizontalPowers, zeropad];


% plot(timevec,vertvec,'r+');

plotdata = transpose([timevec;vertvec;horzvec]);
[Y,I] = sort(plotdata(:,1));
plotdata = plotdata(I,:);

graphPulseFancy(plotdata,1);

% diffs = sort(diff(sort(times)));
% plot(diffs,'r+');
% mintime = mean(diffs(100:1000));