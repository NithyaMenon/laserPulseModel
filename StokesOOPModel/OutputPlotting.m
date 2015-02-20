clc
close all

[ times,I,Q,U,V,widths,IDs,StateHistoryArrays ] = IDtoPulseData( simout );
zeropad = zeros(size(times));
timevec = [ times-widths/2-eps, times-widths/2, times+widths/2,times+widths/2+eps];
Ivec = [ zeropad, I, I, zeropad];


% plot(timevec,vertvec,'r+');

plotdata = transpose([timevec;Ivec]);
[Y,Inds] = sort(plotdata(:,1));
plotdata = plotdata(Inds,:);

graphPulseFancy(plotdata,1);

% diffs = sort(diff(sort(times)));
% plot(diffs,'r+');
% mintime = mean(diffs(100:1000));