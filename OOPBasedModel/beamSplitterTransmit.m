function [ result ] = beamSplitterTransmit( inputs )
%beamSplitter - returns transmitted pulse and reflected pulse based on
%input pulse and transmission percentage
%   Inputs: input pulse, transmission percentage
%   Outputs: transmitted pulse, reflected pulse

% Ensure row vector
size_inputs = size(inputs);
if(size_inputs(2)<size_inputs(1))
    inputs = transpose(inputs);
end

transmitPercentage = inputs(end);

transmitPulseIDs = [];

    for inputPulseID = inputs(1:end-1)
        
        if(inputPulseID <1)
            transmitPulseIDs = [transmitPulseIDs, 0];
            continue

        end
        
        inputPulse = Pulse.getPulse(inputPulseID);
        
        transmitPulse = inputPulse;
        transmitPulse.verticalPower = transmitPercentage*transmitPulse.verticalPower;
        transmitPulse.horizontalPower = transmitPercentage*transmitPulse.horizontalPower;

        transmitPulseID = transmitPulse.ID;
        transmitPulseIDs = [transmitPulseIDs,transmitPulseID ];
        
        
    end
    result = transmitPulseIDs;

end

