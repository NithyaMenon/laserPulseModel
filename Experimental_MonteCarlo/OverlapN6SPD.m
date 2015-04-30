%%
clear
close all
clc

T = [20	40	60	80	100	120	140];

ZeroFF = ffZeroComparison(T,6);

FF = [0.000398144	0.001889658	0.004097732	0.008169267	0.013281903	0.017923079	0.028371673];

RMS = [0.002751888	0.006951871	0.008789432	0.012507935	0.01486529	0.017193725	0.021880048];

IdealFF = [1.88e-05	0.000141612	0.000509095	0.00119575	0.002313902	0.003843913	0.006645507];

hf = figure(1);
% set(hf,'PaperUnits','Points');
set(hf,'Position',[150,550,350*1.15,300*1.15]);

subplot(2,1,1);
semilogy(T, IdealFF,'s-','LineWidth',2);
hold on
plot(T, FF, 'd-','LineWidth',2);
plot(T,ZeroFF,'*-','LineWidth',2,'Color',[0.4940    0.1840    0.5560]);
legend('Ideal UDD','Single Pulse Design','No Filtering',...
    'Location','SouthEast');
grid on
hold off

ylabel('Overlap Integral');
% title('Overlap Integral & RMS Error for N = 6');
title('Overlap Integral for N = 6');
% 
% subplot(2,1,2);
% hold on
% plot(T,RMS,'d-','Color',[0.8500    0.3250    0.0980],'LineWidth',2);
% hold off
% grid on;
% ylabel('RMS Timing Error [ns]');
% xlabel('Total Sequence Length (T) [ns]');
