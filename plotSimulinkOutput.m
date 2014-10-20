function [ ] = plotSimulinkOutput( sim, totalTime )
%PLOTSIMULINKOUTPUT Summary of this function goes here
%   Detailed explanation goes here


data = sim.signals.values;
pulseSequenceDisplay(data, totalTime);

end

