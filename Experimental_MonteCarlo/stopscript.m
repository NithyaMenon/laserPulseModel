
OutputPlotting;

%% Everything from here down is checking for interference

threshold = 1e-4;

importantPulses = IDs(Is>threshold);

%%

% Basically, go through each component, check for interference using 
% important pulses as reference, and print warnings.

for object = PockelsCell.getComponentArray()
    interference = object.checkInterference(importantPulses);
    str = sprintf('PockelsCell %i:',object.ID);
    str = [str, sprintf(' %i interefered pulses',interference)]; 
    display(str);
end



for object = BeamSplitter.getComponentArray()
    interference = object.checkInterference(importantPulses);
    str = sprintf('BeamSplitter %i:',object.ID);
    str = [str, sprintf(' %i interefered pulses',interference)]; 
    display(str);
end

for object = PolarizingBeamSplitter.getComponentArray()
    interference = object.checkInterference(importantPulses);
    str = sprintf('PolarizingBeamSplitter %i:',object.ID);
    str = [str, sprintf(' %i interefered pulses',interference)]; 
    display(str);
end

for object = Delay.getComponentArray()
    interference = object.checkInterference(importantPulses);
    str = sprintf('Delay %i:',object.ID);
    str = [str, sprintf(' %i interefered pulses',interference)]; 
    display(str);
end

for object = LinearPolarizer.getComponentArray()
    interference = object.checkInterference(importantPulses);
    str = sprintf('LinearPolarizer %i:',object.ID);
    str = [str, sprintf(' %i interefered pulses',interference)]; 
    display(str);
end

for object = HalfWavePlate.getComponentArray()
    interference = object.checkInterference(importantPulses);
    str = sprintf('HalfWavePlate %i:',object.ID);
    str = [str, sprintf(' %i interefered pulses',interference)]; 
    display(str);
end



