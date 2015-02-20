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
size_of_timings = int32(inputs(end-1));
timings = inputs(end-1-size_of_timings:end-2);
result = [];

% iterate through inputPulseIDs
for inputPulseID = inputs(1:end-size_of_timings-2)
        
        if(inputPulseID <1)
            result = [result, 0];
            continue

        end
        
        inputPulse = Pulse.getPulse(inputPulseID);
        
        riseFallTime = 8e-9; % Hard-coded
        onTime = 1e-9; % Hard-coded
        PCTrasmittence = 0.85; % Hard-coded
       
        
        
        % Compute s-curve value and value of Tau
        if(min(abs(inputPulse.time - timings))<(onTime/2 + riseFallTime))
            dt = min(abs(inputPulse.time - timings));
            sDt = dt/(onTime/2 + riseFallTime);
            sCurveFall = @(t) (0.0876+1-((-0.135)+ 1.2348./(1+2*exp(-0.012*(t))).^2))/1.0876;
            sCurve = @(sDt) 1*(sDt*600<100) + sCurveFall(sDt*600 - 100).*(sDt*600>=100);
            sCurveVal = sCurve(sDt);
            Tau = sCurveVal*pi;
        else
            Tau = 0;
        end
        
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
        Sout = PCTrasmittence*M*S;
        resultPulse = inputPulse;
        resultPulse.I = Sout(1);
        resultPulse.Q = Sout(2);
        resultPulse.U = Sout(3);
        resultPulse.V = Sout(4);
%         display(S)
%         display(resultPulse)
        
        
         
        % Concatenate resultPulseID to result array
        
        result = [result, resultPulse.ID];
        
        
end
end

