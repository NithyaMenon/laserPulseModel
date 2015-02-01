% Matlab script to run model and generate appropriate plots

inputPulse = inputSequence(76.92307692*10^6, 1, 0,1.016*10^-6);
inputPulse(1,2) = 0;
options = simset('SrcWorkspace', 'current');
test = sim('Digitizing_2PC');

fixfonts = @(h) set(h,'FontName','Arial',...
                      'FontSize',12,...
                      'FontWeight','bold');

%idealOutput = idealPulse(1.0*10^(-6),6,1,(13+8)*10^(-9));
idealOutput = idealPulse(1.0*10^(-6),6,1,16*10^-9);

scaledIdealOutput1 = [idealOutput(:,1), idealOutput(:,2)/2];
scaledIdealOutput3 =[idealOutput(:,1), idealOutput(:,2)/8];
scaledIdealOutput2 =[idealOutput(:,1), idealOutput(:,2)/4];


% % figure(1)
% % fixfonts(title('Input Pulse to Stage A'))
% % fixfonts(ylabel('Log of Relative Pulse Power'));
% % data = graphTwoPulsesFancy(inputPulse, idealOutput, 1);
% % fixfonts(gca);
% % box on
% % fixfonts(legend(data,{'Vertical','Horizontal','Ideal Pulse'},'Location','NorthEast'));
% % print('-dpng',... % png format
% %         '-r300',... % resolution 300 dpi
% %         'input_pulse');  % filename
% % 
% % figure(2)
% % fixfonts(title('Initial PC Selected Pulses in Stage B'))
% % fixfonts(ylabel('Log of Relative Pulse Power'));
% % data = graphTwoPulsesFancy(InitialEOMOut, idealOutput, 2);
% % fixfonts(gca);
% % box on
% % fixfonts(legend(data,{'Vertical','Horizontal','Ideal Pulse'},'Location','NorthEast'));
% % print('-dpng',... % png format
% %         '-r300',... % resolution 300 dpi
% %         'initialEOMOut');  % filename
% % 
% % % figure(18)
% % % fixfonts(title('Initial PC Out'))
% % % graphPulseFancy(initialPCOut, 1);
% % 
% % figure(14)
% % fixfonts(title('Vertical PC Out of Stage B'))
% % fixfonts(ylabel('Log of Relative Pulse Power'));
% % data = graphPulseFancy(vertPCOut, 2);
% % fixfonts(gca);
% % box on
% % fixfonts(legend(data,{'Vertical','Horizontal'},'Location','NorthEast'));
% % print('-dpng',... % png format
% %         '-r300',... % resolution 300 dpi
% %         'VertPCOut');  % filename
% % 
% % % figure(16)
% % % fixfonts(title('Vertical PC In'))
% % %fixfonts(ylabel('Log of Relative Pulse Power'));
% % % graphPulseFancy(vertPCIn, 2);
% % 
% % figure(15)
% % fixfonts(title('Horizontal PC Out of Stage B'))
% % fixfonts(ylabel('Log of Relative Pulse Power'));
% % data = graphPulseFancy(horizPCOut, 2);
% % fixfonts(gca);
% % box on
% % fixfonts(legend(data,{'Vertical','Horizontal'},'Location','NorthEast'));
% % print('-dpng',... % png format
% %         '-r300',... % resolution 300 dpi
% %         'HorizPCOut');  % filename
% % 
% % % figure(17)
% % % fixfonts(title('Horizontal PC In'))
% % %fixfonts(ylabel('Log of Relative Pulse Power'));
% % % graphPulseFancy(horizPCIn, 2);
% % 
% % 
% % figure(3)
% % fixfonts(title('Combined Output of Stage B'))
% % fixfonts(ylabel('Log of Relative Pulse Power'));
% % data = graphTwoPulsesFancy(CombinedPCOut, scaledIdealOutput1, 3);
% % fixfonts(gca);
% % box on
% % fixfonts(legend(data,{'Vertical','Horizontal','Ideal Pulse'},'Location','NorthEast'));
% % print('-dpng',... % png format
% %         '-r300',... % resolution 300 dpi
% %         'RotatedPulses');  % filename
% % 
% % figure(4)
% % fixfonts(title('Output of Stage C'))
% % fixfonts(ylabel('Log of Relative Pulse Power'));
% % data=graphTwoPulsesFancy(PBSDelayOut, scaledIdealOutput1, 4);
% % fixfonts(gca);
% % box on
% % fixfonts(legend(data,{'Vertical','Horizontal','Ideal Pulse'},'Location','NorthEast'));
% % print('-dpng',... % png format
% %         '-r300',... % resolution 300 dpi
% %         'PBSDelayOut');  % filename
% % 
% % % figure(5)
% % % fixfonts(title('After BS Delay Module'))
% % %fixfonts(ylabel('Log of Relative Pulse Power'));
% % % graphTwoPulsesFancy(BSDelayOut, scaledIdealOutput2, 5);
% % 

figure(6)
fixfonts(title('Final Pulse Output from Stage D'))
fixfonts(ylabel('Log of Relative Pulse Power'));
data=graphTwoPulsesFancy(outputPulse, scaledIdealOutput3, 6);
fixfonts(gca);
box on
fixfonts(legend(data,{'Vertical','Horizontal','Ideal Pulse'},'Location','NorthEast'));
print('-dpng',... % png format
        '-r300',... % resolution 300 dpi
        'OutputPulse');  % filename
% % 
% %     
% figure(30)
% fixfonts(title('Output of Stage B*'))
% fixfonts(ylabel('Log of Relative Pulse Power'));
% data=graphTwoPulsesFancy(CombinedPCOut2, scaledIdealOutput2, 30);
% fixfonts(gca);
% box on
% fixfonts(legend(data,{'Vertical','Horizontal','Ideal Pulse'},'Location','NorthEast'));
% print('-dpng',... % png format
%         '-r300',... % resolution 300 dpi
%         'PBSDelayOut_PC2');  % filename
%     
% %Individual Pulse Plots
% figure(7)
% fixfonts(title('Selecting the Fifth Input Pulse in Stage A'))
% fixfonts(ylabel('Log of Relative Pulse Power'));
% data=graphPCFancy(inputPulse, EOMTimings(:,2), idealOutput, 7);
% fixfonts(gca);
% box on
% fixfonts(legend(data,{'Vertical','Horizontal','Ideal Pulse','PC Transmission'},'Location','NorthEast'));
% print('-dpng',... % png format
%         '-r300',... % resolution 300 dpi
%         'pulse5Selection');  % filename
% 
% figure(8)
% fixfonts(title('Rotating the Fifth Pulse in Stage B'))
% fixfonts(ylabel('Log of Relative Pulse Power'));
% data=graphPCFancy(InitialEOMOut, PockelCellTimings(:,2), idealOutput, 8);
% fixfonts(gca);
% box on
% fixfonts(legend(data,{'Vertical','Horizontal','Ideal Pulse','PC Transmission'},'Location','NorthEast'));
% print('-dpng',... % png format
%         '-r300',... % resolution 300 dpi
%         'pulse5Rotation');  % filename
% 
% 
% figure(9)
% fixfonts(title('Recombining the Fifth Pulse in Stage B Output'))
% fixfonts(ylabel('Log of Relative Pulse Power'));
% data=graphTrainFancy(vertPCOut, CombinedPCOut, scaledIdealOutput1, 9);
% fixfonts(gca);
% box on
% fixfonts(legend(data,{'Vertical','Horizontal','Vertical Intermediate','Horizontal Intermediate','Ideal Pulse'},'Location','NorthEast'));
% print('-dpng',... % png format
%         '-r300',... % resolution 300 dpi
%         'pulse5Combine');  % filename
% 
% figure(10)
% fixfonts(title('Output of Stage C'))
% fixfonts(ylabel('Log of Relative Pulse Power'));
% data=graphTrainFancy(CombinedPCOut, PBSDelayOut, scaledIdealOutput1, 10);
% fixfonts(gca);
% box on
% fixfonts(legend(data,{'Vertical','Horizontal','Vertical PBS Out','Horizontal PBS Out','Ideal Pulse'},'Location','NorthEast'));
% print('-dpng',... % png format
%         '-r300',... % resolution 300 dpi
%         'pulse5PBSOut');  % filename
%     
% figure(31)
% fixfonts(title('Recombining the Fifth Pulse in Stage B* Output'))
% fixfonts(ylabel('Log of Relative Pulse Power'));
% data=graphTrainFancy(vertPCOut2, CombinedPCOut2, scaledIdealOutput2, 31);
% fixfonts(gca);
% box on
% fixfonts(legend(data,{'Vertical','Horizontal','Vertical Intermediate','Horizontal Intermediate','Ideal Pulse'},'Location','NorthEast'));
% print('-dpng',... % png format
%         '-r300',... % resolution 300 dpi
%         'pulse5Combine_PC2');  % filename
% 
% figure(32)
% fixfonts(title('Output of Stage C*'))
% fixfonts(ylabel('Log of Relative Pulse Power'));
% data=graphTrainFancy(CombinedPCOut2, outputPulse, scaledIdealOutput3, 32);
% fixfonts(gca);
% box on
% fixfonts(legend(data,{'Vertical','Horizontal','Vertical PBS Out','Horizontal PBS Out','Ideal Pulse'},'Location','NorthEast'));
% print('-dpng',... % png format
%         '-r300',... % resolution 300 dpi
%         'pulse5PBSOut_PC2');  % filename


% figure(11)
% fixfonts(title('BS Delay Module Output'))
% graphTrainFancy(PBSDelayOut, BSDelayOut, scaledIdealOutput2, 11);
% 
% figure(12)
% fixfonts(title('Selecting the Desired Pulse'))
% graphPCFancy(BSDelayOut, FinalPCTiming(:,2), scaledIdealOutput2, 12);

    % figure(13)
    % fixfonts(title('5th Pulse Output'))
    % graphTrainFancy(OutputPulse, OutputPulse, scaledIdealOutput2, 13);
