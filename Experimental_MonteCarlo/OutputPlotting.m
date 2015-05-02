% OutputPlotting.m - for a given simulation run in the workspace, generate
% an output timing diagram showing the intended, residual and ideal pulse
% timings and powers

% Process simulation data
[ Pulses, Is, Qs, Us, Vs, widths, times, IDs] = ProcessSimout(simout);
zeropad = zeros(size(times));
timevec = [ times-widths/2-eps, times-widths/2, times+widths/2,times+widths/2+eps];
Ivec = [ zeropad, Is, Is, zeropad];
Ivec_length = 2*size(zeropad)+ 2;

%T = 300e-9;
n = N;

sortedPulses = sort(Is,'descend');

%Identify the largest n and two Pi/2 pulses 
nLargePulseList = sortedPulses(1:(n+2));
nLargePulse = nLargePulseList(end);

% Seperate out the intended and residual pulses
ImportantPulses_Is = Is(Is>=nLargePulse-eps);
ResidualPulses_Is = Is(Is<nLargePulse-eps);

ImportantPulses_times = times(Is>=nLargePulse-eps);
ResidualPulses_times = times(Is<nLargePulse-eps);

impPulseWidths = widths(Is >= nLargePulse - eps);
resPulseWidths = widths(Is < nLargePulse - eps);

% Manipulate the arrays to have the same dimensions
zeropadImp = ones(size(ImportantPulses_times))*1e-15;
zeropadRes = ones(size(ResidualPulses_times))*1e-15;

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

% Fix uddTimes array to have the same dimensions
uddTimes = [uddSequence-eps;uddSequence;uddSequence+eps];
uddPowers = [zeros(size(uddPowers));uddPowers;zeros(size(uddPowers))];
[uddTimes,Inds] = sort(uddTimes);
uddPowers = uddPowers(Inds);


%%
close all
fixfonts = @(h) set(h,'FontName','Arial',...
                      'FontSize',12,...
                      'FontWeight','bold');
                  
% Choose the pulse colors, both the lines and the fill
% Let's do blue and dark red
linecolors = [0   0 1;   % blue 
              0.7 0 0    % dark red
              0 1 0      % green
              0 0 0];    % black

shading = 0.1;
fillcolors = ones(size(linecolors))*(1-shading)+shading*linecolors;

                  
% Generate output plots by filling the arrays generated earlier such that
% each pulse has the appropriate width
figure(2)
%axis([0 T 0.000000001 2]);
set(gca,'YScale','log');

grid off; 

fixfonts(title(sprintf('Timing Diagram for Digitizing Design, N = %i, T = %3.0f',N,T*1e9)));
fixfonts(xlabel('Time (ns)'));
fixfonts(ylabel('Relative Power'));

hold on
%semilogy(resPlotData(:,1)*1e9,resPlotData(:,2),'Color', 'red','Marker','+');
%stem(resPlotData(:,1)*1e9,resPlotData(:,2),'Color', 'red','Marker','+');

%semilogy(impPlotData(:,1)*1e9, impPlotData(:,2),'Color','blue','LiNeWidth',1,'Marker','+');
%stem(impPlotData(:,1)*1e9, impPlotData(:,2),'Color','blue','LineWidth',2,'Marker','+');

h1 = fill(impPlotData(:,1)*1e9, impPlotData(:,2), fillcolors(1,:));
h2 = fill(resPlotData(:,1)*1e9, resPlotData(:,2), fillcolors(2,:));

set(h1,'EdgeColor',linecolors(1,:),'LineWidth',2,'LineStyle', '-','Marker', '+', 'MarkerSize', 10);
set(h2,'EdgeColor',linecolors(2,:),'LineWidth',2,'LineStyle', '-','Marker', '+', 'MarkerSize', 10);

st = stem(uddTimes*1e9,uddPowers,'--','Color','green','LineWidth',2,'Marker','+');
grid on

legend('Important Pulses', 'Residual Pulses','Ideal Pulses')

fixfonts(gca);
axis([-Inf,Inf,1e-8,0.1]);

td = gca;

% print -dpng -r500 'Ghost Pulses.png'
