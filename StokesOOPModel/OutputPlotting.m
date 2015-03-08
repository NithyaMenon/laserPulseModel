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

%graphPulseFancy(plotdata,1);

% diffs = sort(diff(sort(times)));
% plot(diffs,'r+');
% mintime = mean(diffs(100:1000));

T = 300.0*10^(-9);
n = 6;

idealOutput = idealPulse(T,n,1,0);

fixfonts = @(h) set(h,'FontName','Arial',...
                      'FontSize',12,...
                      'FontWeight','bold');
                  
idealOutput = process_output_list(idealOutput);

figure(2)
fixfonts(title('Output Pulse'));
graphTwoPulsesFancy(plotdata, idealOutput, T*10^9);

[timeError, powerError, residualPowerError, timeMSE, powerMSE, ...
    residualPowerMSE] = analyzePulseTrain(IDs, T, n);

powerError
%residualPowerError
timeError
timeMSE
powerMSE
residualPowerMSE