function [ result ] = delay( u )
%UNTITLED13 Summary of this function goes here
%   Detailed explanation goes here

% Ensure row vector
size_inputs = size(u);
if(size_inputs(2)<size_inputs(1))
    u = transpose(u);
end


delayAmt = u(end);

for inputID = u(1:end-1)
    if(inputID >=1)
        inPulse = Pulse.getPulse(inputID);
        inPulse.time = inPulse.time + delayAmt;
        
        state_creator = sprintf('Delay: %0.3e',delayAmt);
        Pulse.saveStateHistory(inPulse,state_creator);
    end
end

result = u(1:end-1);

end

