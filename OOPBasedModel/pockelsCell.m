function [ result ] = pockelsCell( inputs )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


% Ensure row vector
size_inputs = size(inputs);
if(size_inputs(2)<size_inputs(1))
    inputs = transpose(inputs);
end

size_of_timings = inputs(end);
timings = inputs(end-1-size_of_timings:end-1);

result = [];

for inputPulseID = inputs(1:end-size_of_timings-1)
        
        if(inputPulseID <1)
            result = [result, 0];
            continue

        end
        
        inputPulse = Pulse.getPulse(inputPulseID);
        
        transmitPulse = inputPulse;
        transmitPulse.verticalPower = transmitPercentage*transmitPulse.verticalPower;
        transmitPulse.horizontalPower = transmitPercentage*transmitPulse.horizontalPower;

        transmitPulseID = transmitPulse.ID;
        transmitPulseIDs = [transmitPulseIDs,transmitPulseID ];
        
        
    end


end

