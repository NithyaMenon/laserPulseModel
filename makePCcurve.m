function [ PCcurve ] = makePCcurve(time, tStart, tEnd)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

PCrise = 8.9e-9;
PCfall = 8.9e-9;

tOn = tStart - PCrise;
tOff = tEnd + PCfall;

temp = abs(time - tOn);
[~,startInd] = min(temp);

temp = abs(time - tOff);
[~, endInd] = min(temp);

temp = abs(time - tStart);
[~, riseInd] = min(temp);

temp = abs(time - tEnd);
[~, fallInd] = min(temp);

RFcurve = @(t, tRise)((1.1231664308*10^8)*(t-tRise));

PCcurve = zeros(length(time),1);
PCcurve(startInd:riseInd) = RFcurve(time(startInd:riseInd), tOn);
PCcurve(riseInd:fallInd) = 1;
PCcurve(fallInd:endInd) = -RFcurve(time(fallInd:endInd), tOff);

end

