[ Pulses, Is, Qs, Us, Vs, widths, times, IDs] = ProcessSimout(simout);
zeropad = zeros(size(times));
timevec = [ times-widths/2-eps, times-widths/2, times+widths/2,times+widths/2+eps];
Ivec = [ zeropad, Is, Is, zeropad];

T = 300e-9;
n = 6;

plotdata = transpose([timevec;Ivec]);
[Y,Inds] = sort(plotdata(:,1));
plotdata = plotdata(Inds,:);

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
fixfonts(title('Output Pulse'));

plot(plotdata(:,1),plotdata(:,2),'LineWidth',2);
hold on
plot(uddTimes,uddPowers,'--','LineWidth',2);
