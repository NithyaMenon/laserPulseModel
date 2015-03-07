function [ result ] = pockelsCell( inputs )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


% Ensure row vector
size_inputs = size(inputs);
if(size_inputs(2)<size_inputs(1))
    inputs = transpose(inputs);
end

% Pull off non-inputPulse arguments

psi = inputs(end); % position angle
PCID = inputs(end-1);
pockObject = PockelsObject.getPockelsObject(PCID);

result = [];

% iterate through inputPulseIDs
for inputPulseID = inputs(1:end-2)
        
        if(inputPulseID <1)
            result = [result, 0];
            continue

        end
        
        inputPulse = Pulse.getPulse(inputPulseID);
        
        resultPulse = pockObject.applyPockels(inputPulse,psi);
        
        result = [result, resultPulse.ID];
        
        
end
end

