function [ result ] = quarterWavePlate( inputs )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


% Ensure row vector
size_inputs = size(inputs);
if(size_inputs(2)<size_inputs(1))
    inputs = transpose(inputs);
end

% Pull off non-inputPulse arguments

psi = inputs(end); % position angle
result = [];


% iterate through inputPulseIDs
for inputPulseID = inputs(1:end-1)
        
        if(inputPulseID <1)
            result = [result, 0];
            continue

        end
        
        inputPulse = Pulse.getPulse(inputPulseID);
        
        PlateTrasmittence = 0.1; % Hard-coded
        Tau = pi/2; % Hard-coded for QWP
 
        
        % Compute Mueller matrix
        G = (1/2)*(1+cos(Tau));
        H = (1/2)*(1-cos(Tau));
        
        M = [1 0 0 0;...
            0 (G+H*cos(4*psi)) H*sin(4*psi) -sin(Tau)*sin(2*psi);...
            0 H*sin(4*psi) (G-H*cos(4*psi)) sin(Tau)*cos(2*psi);...
            0 sin(Tau)*sin(2*psi) -sin(Tau)*cos(2*psi) cos(Tau)];
        % Source for Mueller mx:
        % Polarization of Light: Basics to Instruments
        % N. Manset / CFHT
        
        
        % Apply Mueller mx
        S = [inputPulse.I; inputPulse.Q; inputPulse.U; inputPulse.V];
        Sout = PlateTrasmittence*M*S;
        resultPulse = inputPulse;
        resultPulse.I = Sout(1);
        resultPulse.Q = Sout(2);
        resultPulse.U = Sout(3);
        resultPulse.V = Sout(4);
%         display(S)
%         display(resultPulse)
        
        
         
        % Concatenate resultPulseID to result array
        
        state_creator = sprintf('Quarter Wave Plate');
        Pulse.saveStateHistory(resultPulse,state_creator);
        result = [result, resultPulse.ID];
        
        
end


end

