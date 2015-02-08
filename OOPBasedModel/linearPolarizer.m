function [ result ] = linearPolarizer( inputs )
% linearPolarizer - Attenuates polarizations not aligned with the \
% angle of the polarizer
%       Inputs: [input pulses, angle of linear polarizer]
%       Outputs: [output pulses]
% Linear Polarizer Extinction Ratio: 100000:1
% Ensure row vector
size_inputs = size(inputs);
if(size_inputs(2)<size_inputs(1))
    inputs = transpose(inputs);
end


polarizationAngle = inputs(end);

outputPulseIDs = [];

 for inputPulseID = inputs(1:end-1)
        
        if(inputPulseID <1)
            reflectPulseIDs = [reflectPulseIDs,0];
            continue

        end
        
        inputPulse = Pulse.getPulse(inputPulseID);
        
%        if polarizationAngle = 90; 
%         outputPulse = inputPulse;
%         outputPulse.verticalPower = inputPulse.verticalPower *...
%                                     cos(pi/2-polarizationAngle)^2;
%         

end

