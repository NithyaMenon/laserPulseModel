
OutputPlotting;

threshold = 1e-4;

for object = PockelsCell.getComponentArray()
    interference = object.checkInterference(threshold);
    str = sprintf('PockelsCell %i:',object.ID);
    str = [str, sprintf(' %i interefered pulses',length(interference.first))]; 
    display(str);
end

for object = BeamSplitter.getComponentArray()
    interference = object.checkInterference(threshold);
    str = sprintf('BeamSplitter %i:',object.ID);
    str = [str, sprintf(' %i interefered pulses',length(interference.first))]; 
    display(str);
end

for object = PolarizingBeamSplitter.getComponentArray()
    interference = object.checkInterference(threshold);
    str = sprintf('PolarizingBeamSplitter %i:',object.ID);
    str = [str, sprintf(' %i interefered pulses',length(interference.first))]; 
    display(str);
end

for object = Delay.getComponentArray()
    interference = object.checkInterference(threshold);
    str = sprintf('Delay %i:',object.ID);
    str = [str, sprintf(' %i interefered pulses',length(interference.first))]; 
    display(str);
end

for object = LinearPolarizer.getComponentArray()
    interference = object.checkInterference(threshold);
    str = sprintf('LinearPolarizer %i:',object.ID);
    str = [str, sprintf(' %i interefered pulses',length(interference.first))]; 
    display(str);
end

for object = HalfWavePlate.getComponentArray()
    interference = object.checkInterference(threshold);
    str = sprintf('HalfWavePlate %i:',object.ID);
    str = [str, sprintf(' %i interefered pulses',length(interference.first))]; 
    display(str);
end




