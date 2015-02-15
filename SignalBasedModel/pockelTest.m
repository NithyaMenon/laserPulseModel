function [outputPulse, pockelOutput]  = pockelTest( inputPulse, timingArray)
%   Inputs: inputPulses - A list of input pulses
%           timingArray - a list of times at which the EOM should let a
%           pulse through 
%   Outputs: outputPulse - modified output pulse
%
    
pockelSignal = zeros(1, size(inputPulse,1));
ratio = 1000; % set the extinction ratio 
extinctionRatio = ratio/(ratio + 1);
transmissionSignal = zeros(1, size(inputPulse,1));
timeStep = inputPulse(2,1); %the second element of t vector is the time-step
inputPulseMod = inputPulse;
inputPulseMod(:,2:3) = inputPulse(:,2:3)*.985; % insertion loss

for i = 1 : size(timingArray, 1),
    timeOn = timingArray(i) - 5*10^-9; % turn on 4 ns before desired on time
    timeOff = timingArray(i) + 1*10^-9; % turn off 2 ns after the pulse begins
    timeOnIndex = round(timeOn / timeStep); 
    timeOffIndex = round(timeOff / timeStep);
    pockelSignal(timeOnIndex:timeOffIndex) = 1;
    
    nOnElements = round(4*10^-9 / timeStep);
    nConstElements = round(2*10^-9 / timeStep);
    nOffElements = round(4*10^-9 / timeStep);
    
    for j = 1 : nOnElements,
        transmissionSignal(j+timeOnIndex) = (-0.135)+ 1.2348/(1+2*exp(-0.012*(j)))^(1/0.50);
    end
    % (-0.135)+ 1.2348/(1+2*exp(-0.012*(j)))^(1/0.50);
    timeOnIndex = timeOnIndex + nOnElements;
    for j = 1 : nConstElements,
        transmissionSignal(j+timeOnIndex) = 1;
    end
    
    timeOnIndex = timeOnIndex + nConstElements;
    for j = 1 : nOffElements,
        transmissionSignal(j+timeOnIndex) = 1-((-0.135)+ 1.2348/(1+2*exp(-0.012*(j)))^(1/0.50));
   
        
    
    
end

% create a pockel output matrix with the time vector from the input pulse
% pockelOutput = inputPulse(:,1:2);
% pockelOutput(:,2) = pockelSignal;
pockelOutput = inputPulse(:,1:2);
pockelOutput(:,2) = transmissionSignal;


outputPulse = inputPulseMod;
for i = 1:size(outputPulse,1),
    if transmissionSignal(i) > 0, % flip polarization when pockel cell is high
        vertFlip = inputPulseMod(i,2)*extinctionRatio*transmissionSignal(i);
        vertStay = inputPulseMod(i,2)*(1-transmissionSignal(i)) +  inputPulseMod(i,2)*(1-extinctionRatio)*(transmissionSignal(i));
        horizFlip = inputPulseMod(i,3)*extinctionRatio*transmissionSignal(i);
        horizStay = inputPulseMod(i,3)*(1-transmissionSignal(i)) + inputPulseMod(i,3)*(1-extinctionRatio)*(transmissionSignal(i));
        outputPulse(i,2) = vertStay + horizFlip;
        outputPulse(i,3) = vertFlip + horizStay;
    end
end

end

