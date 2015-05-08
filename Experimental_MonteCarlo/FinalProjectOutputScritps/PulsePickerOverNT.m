%%
clear
close all
clc

Ns = [6, 10, 20];

Ts = (390:65:4303)*1e-9;

FinalNs = [];
FinalTs = [];
IdealPerformance = [];
PPRMS = [];
PulsePickerPerformance = [];
NoFilterPerformance = [];

for N = Ns
    for T = Ts
        FinalNs = [FinalNs, N];
        FinalTs = [FinalTs, T];

        IdealPerformance = [IdealPerformance, calculateIdealTimingPerformance(N,T)];

        [PPP,RMSPP,SFPP] = calculatePulsePickerPerformance(N,T);
        PPRMS = [PPRMS,RMSPP];
        PulsePickerPerformance = [PulsePickerPerformance, PPP];
        NoFilterPerformance = [NoFilterPerformance, ffZeroComparison(T*1e9,N)];
        
    end
end

%%
close all

hf = figure(1);
% set(hf,'PaperUnits','Points');
set(hf,'Position',[150,550,350*1.15,300*1.15]);

subplot(3,1,1)
N = Ns(1);
T_N = FinalTs(FinalNs == N)*1e9;
IP_N = IdealPerformance(FinalNs == N);
PPP_N = PulsePickerPerformance(FinalNs == N);
NF_N = NoFilterPerformance(FinalNs == N);
semilogy(T_N, IP_N, 's-', 'LineWidth',2);
hold on
semilogy(T_N, PPP_N, 'd-', 'LineWidth',2,'Color',[0.9290    0.6940    0.1250]);
semilogy(T_N, NF_N, '*-', 'LineWidth',2, 'Color',[0.4940    0.1840    0.5560]);
hold off
axis([0,Inf,1e-2,1e5])
grid on
title 'Pulse Picker Performance: N = 6'
ylabel 'Overlap Integral'
legend 'Ideal UDD' 'Pulse Picker' 'No Filter' 'Location' 'SouthEast'

subplot(3,1,2)
N = Ns(2);
T_N = FinalTs(FinalNs == N)*1e9;
IP_N = IdealPerformance(FinalNs == N);
PPP_N = PulsePickerPerformance(FinalNs == N);
NF_N = NoFilterPerformance(FinalNs == N);
semilogy(T_N, IP_N, 's-', 'LineWidth',2);
hold on
semilogy(T_N, PPP_N, 'd-', 'LineWidth',2,'Color',[0.9290    0.6940    0.1250]);
semilogy(T_N, NF_N, '*-', 'LineWidth',2, 'Color',[0.4940    0.1840    0.5560]);
hold off
axis([0,Inf,1e-2,1e5])
grid on
title 'N = 10'
ylabel 'Overlap Integral'

subplot(3,1,3)
N = Ns(3);
T_N = FinalTs(FinalNs == N)*1e9;
IP_N = IdealPerformance(FinalNs == N);
PPP_N = PulsePickerPerformance(FinalNs == N);
NF_N = NoFilterPerformance(FinalNs == N);
semilogy(T_N, IP_N, 's-', 'LineWidth',2);
hold on
semilogy(T_N, PPP_N, 'd-', 'LineWidth',2,'Color',[0.9290    0.6940    0.1250]);
semilogy(T_N, NF_N, '*-', 'LineWidth',2, 'Color',[0.4940    0.1840    0.5560]);
hold off
axis([0,Inf,1e-2,1e5])
grid on

title 'N = 20'
ylabel 'Overlap Integral'
xlabel 'Total Sequence Length (T) [ns]'




