clc
close all

[ times,I,Q,U,V,widths,IDs,StateHistoryArrays ] = IDtoPulseData( simout );
zeropad = zeros(size(times));
timevec = [ times-widths/2-eps, times-widths/2, times+widths/2,times+widths/2+eps];
Ivec = [ zeropad, I, I, zeropad];


% plot(timevec,vertvec,'r+');

plotdata = transpose([timevec;Ivec]);
[Y,Inds] = sort(plotdata(:,1));
plotdata = plotdata(Inds,:);

graphPulseFancy(plotdata,1);

% diffs = sort(diff(sort(times)));
% plot(diffs,'r+');
% mintime = mean(diffs(100:1000));

idealOutput = idealPulse(300.0*10^(-9),6,1,0);

fixfonts = @(h) set(h,'FontName','Arial',...
                      'FontSize',12,...
                      'FontWeight','bold');


% inputPulseSeq = process_output(inputPulseSeq);
% inputsignal = process_output_list(inputsignal);
idealOutput = process_output_list(idealOutput);
                  
%                   figure(3)
% graphPulseFancy(inputPulseSeq, 3);
% 
% figure(4)
% graphPulseFancy(inputsignal,4);
                  
                  
 figure(2)
 fixfonts(title('Output Pulse'));
 graphTwoPulsesFancy(plotdata, idealOutput, 2);
% %graphPulseFancy(inputsignal, 2);
% 


% subplot(3,3,1)
% fixfonts(title('Input Pulse'))
% inputPulseSeq = process_output(inputPulseSeq);
% graphTwoPulsesFancy(inputPulseSeq, idealOutput, 2);
% graphPulseFancy(inputPulseSeq, 2);
% subplot(3,3,2)
% fixfonts(title('First EOM Selected Pulses (Stage A)'))
% selectedPulses = process_output(selectedPulses);
% graphTwoPulsesFancy(selectedPulses, idealOutput, 2);
% graphPulseFancy(selectedPulses, 2);
% subplot(3,3,3)
% fixfonts(title('Second EOM Rotated Pulses (Stage B)'))
% PC1Out = process_output(PC1Out);
% graphTwoPulsesFancy(PC1Out, idealOutput, 2);
% graphPulseFancy(PC1Out, 2);
% subplot(3,3,4)
% fixfonts(title('PBS Transmitted Pulses (Stage C)'))
% PBS1Reflect = process_output(PBS1Reflect);
% graphTwoPulsesFancy(PBS1Reflect, idealOutput, 2);
% graphPulseFancy(PBS1Reflect, 2);
% subplot(3,3,5)
% fixfonts(title('PBS Reflected Pulses (Stage C)'))
% PBS1Transmit = process_output(PBS1Transmit);
% graphTwoPulsesFancy(PBS1Transmit, idealOutput, 2);
% graphPulseFancy(PBS1Transmit, 2);
% subplot(3,3,6)
% fixfonts(title('Delay 1/Delay 2 Output Pulses'))
% Delay1Delay2Out = process_output(Delay1Delay2Out);
% graphTwoPulsesFancy(Delay1Delay2Out, idealOutput, 2);
% graphPulseFancy(Delay1Delay2Out, 2);
% subplot(3,3,7)
% fixfonts(title('Delay 2/Delay 3 Output Pulses'))
% Delay2Delay3Out = process_output(Delay2Delay3Out);
% graphTwoPulsesFancy(Delay2Delay3Out, idealOutput, 2);
% graphPulseFancy(Delay2Delay3Out, 2);
% subplot(3,3,8)
% fixfonts(title('Input into Second EOM'))
% PC2In = process_output(PC2In);
% graphTwoPulsesFancy(PC2In, idealOutput, 2);
% graphPulseFancy(PC2In, 2);
% subplot(3,3,9)
% fixfonts(title('Output of Second EOM'))
% PC2Out = process_output(PC2Out);
% graphTwoPulsesFancy(PC2Out, idealOutput, 2);
% graphPulseFancy(PC2Out, 2);
