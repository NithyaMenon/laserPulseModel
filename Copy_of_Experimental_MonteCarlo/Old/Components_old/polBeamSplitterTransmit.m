function [ results ] = polBeamSplitterTransmit( inputs )
%beamSplitter - returns transmitted pulse based on
%input pulse and transmission percentage
%   Inputs: [input pulses, transmission percentage]
%   Outputs: [transmitted pulses]
%Notes: This is a 50-50 beam splitter

% Ensure row vector
size_inputs = size(inputs);
if(size_inputs(2)<size_inputs(1))
    inputs = transpose(inputs);
end

attenuationFactor = inputs(end);

results = [];

% Define the transmit axis
psi = pi/2;

J_pass = [cos(psi)^2, cos(psi)*sin(psi);...
    sin(psi)*cos(psi), sin(psi)^2];
A = [ 1 0 0 1;...
    1 0 0 -1;...
    0 1 1 0;...
    0 1i -1i 0];
M_pass = A*kron(J_pass,conj(J_pass))*inv(A);

results = [];

    for inputPulseID = inputs(1:end-1)
        
        if(inputPulseID <1)
            results = [results,0];
            continue
        end
        
        inputPulse = Pulse.getPulse(inputPulseID);
        
        S = [inputPulse.I;inputPulse.Q;inputPulse.U;inputPulse.V];
        Sout = attenuationFactor*(M_pass)*S;
        inputPulse.I = Sout(1);
        inputPulse.Q = Sout(2);
        inputPulse.U = Sout(3);
        inputPulse.V = Sout(4);
        
        state_creator = sprintf('Polarizing Beam Splitter Transmit');
        Pulse.saveStateHistory(inputPulse,state_creator);
        results = [results,inputPulse.ID];
        
    end

end

