% Matlab script to run model and generate appropriate plots

inputPulse = inputSequence(76.92307692*10^6, 1, 0,1*10^-6);
options = simset('SrcWorkspace', 'current');
test = sim('Digitizing_3delays_1us');

graphPulseFancy(inputPulse, 1);
graphPulseFancy(InitialEOMOut, 2);
graphPulseFancy(PockelCellOutput, 3);
graphPulseFancy(PBSDelayOut, 4);
graphPulseFancy(BSDelayOut, 5);
graphPulseFancy(OutputPulse, 6);

graphPCFancy(inputPulse, EOMTimings(:,2), OutputPulse, 7);
graphPCFancy(PockelCellInput, PockelCellTimings(:,2), OutputPulse, 8);

graphTrainFancy(vertPCOut, CombinedPCOut, OutputPulse, 9);
graphTrainFancy(CombinedPCOut, PBSDelayOut, OutputPulse, 10);
graphTrainFancy(PBSDelayOut, BSDelayOut, OutputPulse, 11);

graphPCFancy(BSDelayOut, FinalPCTiming(:,2), OutputPulse, 12);


disp(OutputPulse);
