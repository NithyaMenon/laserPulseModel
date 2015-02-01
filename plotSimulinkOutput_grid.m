% Matlab script to run model and generate appropriate plots

inputPulse = inputSequence(76.92307692*10^6, 1, 0,1.016*10^-6);
inputPulse(1,2) = 0;
options = simset('SrcWorkspace', 'current');
test = sim('Digitizing_2PC');

fixfonts = @(h) set(h,'FontName','Arial',...
                      'FontSize',12,...
                      'FontWeight','bold');

%idealOutput = idealPulse(1.0*10^(-6),6,1,(13+8)*10^(-9));
idealOutput = idealPulse(1.0*10^(-6),6,1,16*10^(-9));

figure(1)
subplot(3,2,1)
fixfonts(title('Input Pulse'))
graphTwoPulsesFancy(inputPulse, idealOutput, 1);
subplot(3,2,2)
fixfonts(title('Initial PC Selected Pulses (Stage A)'))
graphTwoPulsesFancy(InitialEOMOut, idealOutput, 1);
subplot(3,2,3)
fixfonts(title('First Rotated Pulses (Stage B)'))
graphTwoPulsesFancy(CombinedPCOut, idealOutput, 1);
subplot(3,2,4)
fixfonts(title('After First PBS Delay Module (Stage C)'))
graphTwoPulsesFancy(PBSDelayOut, idealOutput, 1);
subplot(3,2,5)
fixfonts(title('Second Rotated Pulses (Stage B*)'))
graphTwoPulsesFancy(CombinedPCOut2, idealOutput, 1);
subplot(3,2,6)
fixfonts(title('After Second PBS Delay Module (Stage C*)'))
graphTwoPulsesFancy(outputPulse, idealOutput, 1);

figure(2)
subplot(3,2,1)
fixfonts(title('Selecting the Fifth Input Pulse'))
graphPCFancy(inputPulse, EOMTimings(:,2), idealOutput, 2);
subplot(3,2,2)
fixfonts(title('First Pulse Rotation (Stage B)'))
graphPCFancy(InitialEOMOut, PockelCellTimings(:,2), idealOutput, 2);
subplot(3,2,3)
fixfonts(title('Recombining the Fifth Pulse (Stage B)'))
graphTrainFancy(vertPCOut, CombinedPCOut, idealOutput, 2);
subplot(3,2,4)
fixfonts(title('After First PBS Delay Module (Stage C)'))
graphTrainFancy(CombinedPCOut, PBSDelayOut, idealOutput, 2);
subplot(3,2,5)
fixfonts(title('Second Pulse Rotation (Stage B*)'))
graphPCFancy(PBSDelayOut, PockelCellTimings2(:,2), idealOutput, 2);
subplot(3,2,6)
fixfonts(title('After Second PBS Delay Module (Stage C*)'))
graphTrainFancy(CombinedPCOut2,outputPulse, idealOutput, 2);
