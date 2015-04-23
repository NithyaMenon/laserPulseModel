[ Pulses, Is, Qs, Us, Vs, widths, times, IDs] = ProcessSimout(simout);
zeropad = zeros(size(times));
timevec = [ times-widths/2-eps, times-widths/2, times+widths/2,times+widths/2+eps];
Ivec = [ zeropad, Is, Is, zeropad];
Ivec_length = 2*size(zeropad)+ 2;

T = 300e-9;
n = 4;

sortedPulses = sort(Is,'descend');

%Identify the largest n and two Pi/2 pulses 
nLargePulseList = sortedPulses(1:(n+2));
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

% Scale UDD times to match a constant offset present in the first pulse
uddSequence = (T*sin(uddTimes).^2);
uddSequence = [0;uddSequence;T]+ImportantPulses_times(1);
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

grid off; 

fixfonts(title('Output Pulse'));
fixfonts(xlabel('Time (ns)'));
fixfonts(ylabel('Relative Power'));

hold on
%semilogy(resPlotData(:,1)*1e9,resPlotData(:,2),'Color', 'red','Marker','+');
stem(resPlotData(:,1)*1e9,resPlotData(:,2),'Color', 'red','Marker','+');

%semilogy(impPlotData(:,1)*1e9, impPlotData(:,2),'Color','blue','LineWidth',1,'Marker','+');
stem(impPlotData(:,1)*1e9, impPlotData(:,2),'Color','blue','LineWidth',2,'Marker','+');

stem(uddTimes*1e9,uddPowers,'--','Color','green','LineWidth',2,'Marker','+');
grid on

legend('Residual Pulses', 'Important Pulses','Ideal Pulses')

print -dpng -r500 'Ghost Pulses.png'
