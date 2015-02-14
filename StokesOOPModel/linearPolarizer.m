function [ results ] = linearPolarizer( inputs )
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

psi = inputs(end);

% Compute Jones Matrix
J = [cos(psi)^2, cos(psi)*sin(psi);...
    sin(psi)*cos(psi), sin(psi)^2];
% Compute Mueller Matrix
A = [ 1 0 0 1;...
    1 0 0 -1;...
    0 1 1 0;...
    0 1i -1i 0];
M = A*kron(J,conj(J))*inv(A);


results = [];

 for inputPulseID = inputs(1:end-1)
        
        if(inputPulseID <1)
            results = [results,0];
            continue
        end
        
        inputPulse = Pulse.getPulse(inputPulseID);
        
        % Apply Mueller matrix
        S = [inputPulse.I;inputPulse.Q;inputPulse.U;inputPulse.V];
        Sout = M*S; % TODO Transmittence
        inputPulse.I = Sout(1);
        inputPulse.Q = Sout(2);
        inputPulse.U = Sout(3);
        inputPulse.V = Sout(4);
        
        results = [results,inputPulse.ID];
        % Apply extinction ratio
         % TODO
 end
 
end

