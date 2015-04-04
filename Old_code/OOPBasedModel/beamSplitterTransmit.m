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
        transmitPulse.verticalPower = attenuatationFactor*transmitPulse.verticalPower;
        transmitPulse.horizontalPower = attenuatationFactor*transmitPulse.horizontalPower;

        transmitPulseID = transmitPulse.ID;
        transmitPulseIDs = [transmitPulseIDs,transmitPulseID ];
        
        
    end
    result = transmitPulseIDs;

end

