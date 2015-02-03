function [ result ] = beamSplitterReflect( inputs )
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

reflectPulseIDs = [];

    for inputPulseID = inputs(1:end-1)
        
        if(inputPulseID <1)
            reflectPulseIDs = [reflectPulseIDs,0];
            continue

        end
        
        inputPulse = Pulse.getPulse(inputPulseID);
        
        reflectPulse = Pulse([inputPulse.time,...
            (1 - transmitPercentage)*inputPulse.verticalPower,...
            (1 - transmitPercentage)*inputPulse.horizontalPower,...
            inputPulse.width]);

        reflectPulseID = reflectPulse.ID;
        reflectPulseIDs = [reflectPulseIDs,reflectPulseID];
        
        
    end
    result = reflectPulseIDs;

end

