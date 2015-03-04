function [ results ] = signalSampler( inputs )


% Ensure row vector
size_inputs = size(inputs);
if(size_inputs(2)<size_inputs(1))
    inputs = transpose(inputs);
end


results = [];

 for inputPulseID = inputs(1:end)
        
        if(inputPulseID <1)
            results = [results,0];
            continue
        end
        
        inputPulse = Pulse.getPulse(inputPulseID);
        
        sampleObject = samplePulseObject(inputPulse);
        results = [results,sampleObject.ID];
 end
 
end

