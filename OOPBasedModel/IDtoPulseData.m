function [ times,verticalPowers,horizontalPowers,widths ] = IDtoPulseData( simout )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

u = simout.Data;

u = u(u~=0);

times = [];
verticalPowers = [];
horizontalPowers = [];
widths = [];

for i = u
    p = Pulse.getPulse(i);
    times = [times, p.time];
    verticalPowers = [verticalPowers, p.verticalPower];
    horizontalPowers = [ horizontalPowers, p.horizontalPower];
    widths = [widths, p.width];
end




end

