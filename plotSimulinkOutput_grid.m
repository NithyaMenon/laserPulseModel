% Matlab script to run model and generate appropriate plots

inputPulse = inputSequence(76.92307692*10^6, 1, 0,1.5*10^-6);
inputPulse(1,2) = 0;
options = simset('SrcWorkspace', 'current');
test = sim('Digitizing_3delays_1us');

fixfonts = @(h) set(h,'FontName','Arial',...
                      'FontSize',12,...
                      'FontWeight','bold');

%idealOutput = idealPulse(1.0*10^(-6),6,1,(13+8)*10^(-9));
idealOutput = idealPulse(1.0*10^(-6),6,1,0);

figure(1)
fixfonts(title('Input Pulse'))
graphPulseFancy(inputPulse, 1);
subplot(3,2,2)
fixfonts(title('Initial PC Selected Pulses'))
graphPulseFancy(InitialEOMOut, 1);
subplot(3,2,3)
fixfonts(title('Rotated Pulses'))
graphPulseFancy(CombinedPCOut, 1);
subplot(3,2,4)
fixfonts(title('After PBS Delay Module'))
graphPulseFancy(PBSDelayOut, 1);
subplot(3,2,5)
fixfonts(title('After BS Delay Module'))
graphPulseFancy(BSDelayOut, 1);
subplot(3,2,6)
fixfonts(title('Final Pulse Sequence'))
graphPulseFancy(OutputPulse, 1);

figure(2)
subplot(3,2,1)
fixfonts(title('Selecting the Fifth Input Pulse'))
graphPCFancy(inputPulse, EOMTimings(:,2), idealOutput, 2);
subplot(3,2,2)
fixfonts(title('Rotating the Fifth Pulse'))
graphPCFancy(InitialEOMOut, PockelCellTimings(:,2), idealOutput, 2);
subplot(3,2,3)
fixfonts(title('Recombining the Fifth Pulse'))
graphTrainFancy(vertPCOut, CombinedPCOut, idealOutput, 2);
subplot(3,2,4)
fixfonts(title('PBS Delay Module Output'))
graphTrainFancy(CombinedPCOut, PBSDelayOut, idealOutput, 2);
subplot(3,2,5)
fixfonts(title('BS Delay Module Output'))
graphTrainFancy(PBSDelayOut, BSDelayOut, idealOutput, 2);
subplot(3,2,6)
fixfonts(title('Selecting the Desired Pulse'))
graphPCFancy(BSDelayOut, FinalPCTiming(:,2), idealOutput, 2);


disp(OutputPulse);
