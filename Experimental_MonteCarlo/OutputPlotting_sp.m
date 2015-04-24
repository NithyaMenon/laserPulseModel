[ Pulses, Is, Qs, Us, Vs, widths, times, IDs] = ProcessSimout(simout);
zeropad = zeros(size(times));
timevec = [ times-widths/2-eps, times-widths/2, times+widths/2,times+widths/2+eps];
Ivec = [ zeropad, Is, Is, zeropad];
Ivec_length = 2*size(zeropad)+ 2;

%T = 40e-9;
%n = 14;

num_pulses_start = 100;
timings = 0:13e-9:(num_pulses_start-1)*13e-9;



n = N;
sortedPulses = sort(Is,'descend');
% Identify the n Pi pulses and the 2 Pi/2 pulses
nLargePulseList = sortedPulses(1:(n+2));
nLargePulse = nLargePulseList(end);

ImportantPulses_Is = Is(Is>=nLargePulse-eps);
ResidualPulses_Is = Is(Is<nLargePulse-eps);

ImportantPulses_times = times(Is>=nLargePulse-eps);
ResidualPulses_times = times(Is<nLargePulse-eps);

impPulseWidths = widths(Is >= nLargePulse - eps);
resPulseWidths = widths(Is < nLargePulse - eps);

%Set the lowest power to a near zero constant since we will take the log
zeropadImp = ones(size(ImportantPulses_times))*1e-15;
zeropadRes = ones(size(ResidualPulses_times))*1e-15;

impTimeVec = [ ImportantPulses_times-impPulseWidths/2 - eps, ImportantPulses_times-impPulseWidths/2, ImportantPulses_times+impPulseWidths/2, ImportantPulses_times+impPulseWidths/2 + eps];
ImportantPulses_Ivec = [zeropadImp, ImportantPulses_Is, ImportantPulses_Is, zeropadImp];

resTimeVec = [ ResidualPulses_times - resPulseWidths/2 - eps, ResidualPulses_times-resPulseWidths/2, ResidualPulses_times+resPulseWidths/2, ResidualPulses_times+resPulseWidths/2 + eps];
ResidualPulses_Ivec = [zeropadRes, ResidualPulses_Is, ResidualPulses_Is, zeropadRes];

% Choose the pulse colors, both the lines and the fill
% Let's do blue and dark red
linecolors = [0   0 1;   % blue 
              0.7 0 0    % dark red
              0 1 0      % green
              0 0 0];    % black

shading = 0.1;
fillcolors = ones(size(linecolors))*(1-shading)+shading*linecolors;


impPlotData = transpose([impTimeVec; ImportantPulses_Ivec]);
[Y,Inds] = sort(impPlotData(:,1));
impPlotData = impPlotData(Inds,:);

resPlotData = transpose([resTimeVec; ResidualPulses_Ivec]);
[Y,Inds] = sort(resPlotData(:,1));
resPlotData = resPlotData(Inds,:);

uddTimes =(pi/(2*n+2):pi/(2*n+2):n*pi/(2*n+2))';
uddSequence = T*sin(uddTimes).^2;
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
axis([-5 (T*1e9+5) 0.0000001 2]);
set(gca,'YScale','log');

grid off; 

fixfonts(title('Output Pulse'));
fixfonts(xlabel('Time (ns)'));
fixfonts(ylabel('Relative Power'));

hold on
%semilogy(resPlotData(:,1)*1e9,resPlotData(:,2),'Color', 'red','Marker','+');
%stem(resPlotData(:,1)*1e9,resPlotData(:,2),'Color', 'red','Marker','+','BaseValue',1e-9);
h1 = fill(impPlotData(:,1)*1e9, impPlotData(:,2), fillcolors(1,:));
h2 = fill(resPlotData(:,1)*1e9, resPlotData(:,2), fillcolors(2,:));

set(h1,'EdgeColor',linecolors(1,:),'LineWidth',2,'LineStyle', '-','Marker', '+', 'MarkerSize', 10);
set(h2,'EdgeColor',linecolors(2,:),'LineWidth',2,'LineStyle', '-','Marker', '+', 'MarkerSize', 10);

%semilogy(impPlotData(:,1)*1e9, impPlotData(:,2),'Color','blue','LineWidth',1,'Marker','+');
%stem(impPlotData(:,1)*1e9, impPlotData(:,2),'Color','blue','LineWidth',2,'Marker','+','BaseValue',1e-9);

stem(uddTimes*1e9,uddPowers,'--','Color','green','LineWidth',2,'Marker','+','BaseValue',1e-9);
grid on

legend('Important Pulses', 'Residual Pulses','Ideal Pulses')

fixfonts(gca);

print -dpng -r500 'Ghost Pulses.png'
