function [ results ] = polBeamSplitterReflect( inputs )
%beamSplitter - returns reflect pulse based on
%input pulse and transmission percentage
%   Inputs: [input pulses, transmission percentage]
%   Outputs: [reflect pulses]
%This is a 50-50 beam splitter.

% Ensure row vector
size_inputs = size(inputs);
if(size_inputs(2)<size_inputs(1))
    inputs = transpose(inputs);
end

attenuationFactor = inputs(end);

% Specify the reflect axis
psi_2 = 0;

J_stop = [cos(psi_2)^2, cos(psi_2)*sin(psi_2);...
    sin(psi_2)*cos(psi_2), sin(psi_2)^2];

% Compute Mueller Matrix
A = [ 1 0 0 1;...
    1 0 0 -1;...
    0 1 1 0;...
    0 1i -1i 0];

M_stop = A*kron(J_stop,conj(J_stop))*inv(A);

results = [];

    for inputPulseID = inputs(1:end-1)
        
        if(inputPulseID <1)
            results = [results,0];
            continue
        end
        
        inputPulse = Pulse.clonePulse(Pulse.getPulse(inputPulseID));
        
         % Apply Mueller matrix
        S = [inputPulse.I;inputPulse.Q;inputPulse.U;inputPulse.V];
        Sout = attenuationFactor*M_stop*S;
        inputPulse.I = Sout(1);
        inputPulse.Q = Sout(2);
        inputPulse.U = Sout(3);
        inputPulse.V = Sout(4);
        
        results = [results,inputPulse.ID];
         
    end

end
