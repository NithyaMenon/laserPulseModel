%%
% clearAll;
clear
% close all
clc

% load('FinalResultSet_5Runs_N6_Subset.mat')
load('FinalResultSet_20Runs_N6.mat');

SubSet = FinalResultSet([FinalResultSet.seqFail] == 0);

Ns = [SubSet(:).N];
Ts = [SubSet(:).T];
DigitPerformance = [SubSet(:).TimingStatistics];
DigitPerformance = [DigitPerformance(:).Mean];
DPRMS = DigitPerformance(2,:);
DigitPerformance = DigitPerformance(1,:);

IdealPerformance = [];
PulsePickerPerformance = [];
PPRMS = [];

for i = 1:length(Ns)
    N = Ns(i);
    T = Ts(i);
    IdealPerformance = [IdealPerformance, calculateIdealTimingPerformance(N,T)];
    [PPP,RMSPP,SFPP] = calculatePulsePickerPerformance(N,T);
    PPRMS = [PPRMS,RMSPP];
    PulsePickerPerformance = [PulsePickerPerformance, calculatePulsePickerPerformance(N,T)];
    
end

Ts_6 = Ts(Ns == 6);
ZeroFF_6 = ffZeroComparison(Ts_6*1e9,6);
Ideal_6 = IdealPerformance(Ns == 6);
Digit_6 = DigitPerformance(Ns == 6);
PP_6  = PulsePickerPerformance(Ns == 6);
PPRMS_6 = PPRMS(Ns == 6);
DigitRMS_6 = DPRMS(Ns == 6);
Digit_6 = Digit_6.*(Digit_6<PP_6) + PP_6.*(Digit_6>=PP_6);
DigitRMS_6 = DigitRMS_6.*(Digit_6<PP_6) + PPRMS_6.*(Digit_6>=PP_6);

hf = figure(1);
% set(hf,'PaperUnits','Points');
set(hf,'Position',[150,550,350*1.15,300*1.15]);

% subplot(2,1,1);
subplot(2,1,2);
semilogy(Ts_6*1e9, Ideal_6,'s-','LineWidth',2);
hold on
plot(Ts_6*1e9, Digit_6, 'd-','LineWidth',2);
plot(Ts_6*1e9, PP_6, '^-','LineWidth',2);
plot(Ts_6*1e9, ZeroFF_6, '*-','LineWidth',2,'Color',[0.4940    0.1840    0.5560]);
% legend('Ideal UDD','Digitizing Design','Pulse Picker',...
%     'Ideal UDD',...
%     'Location','NorthWest');
legend('Ideal UDD','Digitizing Design','Pulse Picker',...
    'No Filtering',...
    'Location','SouthEast');
grid on
hold off

ylabel('Overlap Integral');
% title('Overlap Integral & RMS Error for N = 6');

% subplot(2,1,2);
% hold on
% plot(Ts_6*1e9,DigitRMS_6,'d-','Color',[0.8500    0.3250    0.0980],'LineWidth',2);
% plot(Ts_6*1e9, PPRMS_6,'^-','Color',[0.9290    0.6940    0.1250],'LineWidth',2);
% hold off
% grid on;
% ylabel('RMS Timing Error [ns]');
xlabel('Total Sequence Lentgth (T) [ns]');
