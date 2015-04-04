function [ result ] = beamSplitterTransmit( inputs )
%beamSplitter - returns transmitted pulse based on
%input pulse and transmission percentage
%   Inputs: [input pulses, transmission percentage]
%   Outputs: [transmitted pulses]
%Notes: This is a 50-50 beam splitter

% Ensure row vector
size_inputs = size(inputs);
if(size_inputs(2)<size_inputs(1))
    inputs = transpose(inputs);
end

attenuatationFactor = inputs(end);

transmitPulseIDs = [];

    for inputPulseID = inputs(1:end-1)
        
        if(inputPulseID <1)
            transmitPulseIDs = [transmitPulseIDs, 0];
            continue

        end
        
        inputPulse = Pulse.getPulse(inputPulseID);
        
        transmitPulse = inputPulse;
        transmitPulse.I = attenuatationFactor*transmitPulse.I;
        transmitPulse.Q = attenuatationFactor*transmitPulse.Q;
        transmitPulse.U = attenuatationFactor*transmitPulse.U;
        transmitPulse.V = attenuatationFactor*transmitPulse.V;
 
        transmitPulseID = transmitPulse.ID;
        transmitPulseIDs = [transmitPulseIDs,transmitPulseID ];
        
        state_creator = sprintf('Beam Splitter Transmit');
        Pulse.saveStateHistory(transmitPulse,state_creator);
        
    end
    result = transmitPulseIDs;

end

