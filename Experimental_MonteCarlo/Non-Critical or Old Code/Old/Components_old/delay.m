function [ result ] = delay( u )
%DELAY Applies a specified delay to input pulses
%   Usage: resultPulseIDs =
%   delay([inputPulseID1,inputPulseID2,...,delayAmt]);
%   The function interprets any arguments except for the last (which 
%   specifies delay amout) as input pulse IDs, and treats only 0 as 
%   a 'null pulse' (doesn't act). 

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

