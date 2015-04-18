[ Pulses, Is, Qs, Us, Vs, widths, times, IDs] = ProcessSimout(simout);
zeropad = zeros(size(times));
timevec = [ times-widths/2-eps, times-widths/2, times+widths/2,times+widths/2+eps];
Ivec = [ zeropad, Is, Is, zeropad];
Ivec_length = 2*size(zeropad)+ 2;

T = 300e-9;
n = 6;

sortedPulses = sort(Is,'descend');
nLargePulseList = sortedPulses(1:n);
nLargePulse = nLargePulseList(end);

ImportantPulses_Is = Is(Is>=nLargePulse-eps);
ResidualPulses_Is = Is(Is<nLargePulse-eps);

ImportantPulses_times = times(Is>=nLargePulse-eps);
ResidualPulses_times = times(Is<nLargePulse-eps);

impPulseWidths = widths(Is >= nLargePulse - eps);
resPulseWidths = widths(Is < nLargePulse - eps);

zeropadImp = zeros(size(ImportantPulses_times));
zeropadRes = zeros(size(ResidualPulses_times));

impTimeVec = [ ImportantPulses_times-impPulseWidths/2 - eps, ImportantPulses_times-impPulseWidths/2, ImportantPulses_times+impPulseWidths/2, ImportantPulses_times+impPulseWidths/2 + eps];
ImportantPulses_Ivec = [zeropadImp, ImportantPulses_Is, ImportantPulses_Is, zeropadImp];

resTimeVec = [ ResidualPulses_times - resPulseWidths/2 - eps, ResidualPulses_times-resPulseWidths/2, ResidualPulses_times+resPulseWidths/2, ResidualPulses_times+resPulseWidths/2 + eps];
ResidualPulses_Ivec = [zeropadRes, ResidualPulses_Is, ResidualPulses_Is, zeropadRes];

impPlotData = transpose([impTimeVec; ImportantPulses_Ivec]);
[Y,Inds] = sort(impPlotData(:,1));
impPlotData = impPlotData(Inds,:);

resPlotData = transpose([resTimeVec; ResidualPulses_Ivec]);
[Y,Inds] = sort(resPlotData(:,1));
resPlotData = resPlotData(Inds,:);

uddTimes =(pi/(2*n+2):pi/(2*n+2):n*pi/(2*n+2))';
uddSequence = T*sin(uddTimes).^2;
uddPowers = ones(size(uddSequence))*max(Is);
uddTimes = [uddSequence-eps;uddSequence;uddSequence+eps];
uddPowers = [zeros(size(uddPowers));uddPowers;zeros(size(uddPowers))];
[uddTimes,Inds] = sort(uddTimes);
uddPowers = uddPowers(Inds);


%%
close all
fixfonts = @(h) set(h,'FontName','Arial',...
                      'FontSize',12,...
                      'FontWeight','bold');
                  

figure(2)
%axis([0 T 0.000000001 2]);
%set(gca,'YScale','log');

fixfonts(title('Output Pulse'));

hold on
semilogy(resPlotData(:,1)*1e9,resPlotData(:,2),'Color', 'red','Marker','+');
%plot(resPlotData(:,1)*1e9,resPlotData(:,2),'Color', 'red');

semilogy(impPlotData(:,1)*1e9, impPlotData(:,2),'Color','blue','LineWidth',1,'Marker','+');
%plot(impPlotData(:,1)*1e9, impPlotData(:,2),'Color','blue','LineWidth',1);

semilogy(uddTimes*1e9,uddPowers,'--','Color','green','LineWidth',1);
grid on

print -dpng -r500 'Ghost Pulses.png'
