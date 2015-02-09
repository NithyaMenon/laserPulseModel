function [ result ] = pockelsCell( inputs )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


% Ensure row vector
size_inputs = size(inputs);
if(size_inputs(2)<size_inputs(1))
    inputs = transpose(inputs);
end

% Pull off non-inputPulse arguments

size_of_timings = inputs(end);
timings = inputs(end-1-size_of_timings:end-1);

result = [];


% iterate through inputPulseIDs
for inputPulseID = inputs(1:end-size_of_timings-1)
        
        if(inputPulseID <1)
            result = [result, 0];
            continue

        end
        
        inputPulse = Pulse.getPulse(inputPulseID);
        
        % Convert inputPulse to resultPulseID
        riseFallTime = 8e-9; % Hard-coded
        onTime = 1e-9; % Hard-coded
        PCTrasmittence = 0.85;
        
        if(min(abs(inputPulse.time - timings))<(onTime/2 + riseFallTime))
            tau = min(abs(inputPulse.time - timings));
            sTau = tau/(onTime/2 + riseFallTime);
            sCurveFall = @(t) (0.0876+1-((-0.135)+ 1.2348./(1+2*exp(-0.012*(t))).^2))/1.0876;
            sCurve = @(sTau) 1*(sTau*600<100) + sCurveFall(sTau*600 - 100).*(sTau*600>=100);
            sCurveVal = sCurve(sTau);
            dTheta = sCurveVal*pi/2;
        else
            dTheta = 0;
        end
        theta = atan2(inputPulse.verticalPower,inputPulse.horizontalPower);
        R = norm([inputPulse.verticalPower,inputPulse.horizontalPower]);
        R = R*PCTrasmittence;
        theta = theta + dTheta;
        inputPulse.verticalPower = R*sin(theta);
        inputPulse.horizontalPower = R*cos(theta);
        resultPulseID = inputPulse.ID;
         
        % Concatenate resultPulseID to result array
        
        result = [result, resultPulseID];
        
        
end


end

