clear
Pulse.clearPulses();
PockelsObject.clearPockels();
close all
clc

%%
sCurveFall = @(t) (0.0112+(0.0876+1-((-0.135)+ 1.2348./(1+2*exp(-0.012*(t*1e11))).^2))/1.0876)/1.0092;
PCcurve = @(t,tStart,tEnd) sCurveFall(-(t-tStart)).*(t<tStart) + ...
                1.*(tStart<=t && t<tEnd) + ...
                sCurveFall(t-tEnd).*(t>=tEnd);
fun = @(t) PCcurve(t,10e-9,20e-9);            

% tt = (0:0.01:100)*1e-9;
% plot(tt,arrayfun(fun,tt));


display(PCcurve(1e-9,0,5e-9))
%%            
clear
Pulse.clearPulses();
PockelsObject.clearPockels();
close all
clc


PC1 = PockelsObject([0,5,20,25]*1e-9);

p1 = Pulse([10e-9]);

% PC1.applyPockels(p1,pi/4);

result = pockelsCell([1,1,pi/4]);

Pulse.printStateHistory(p1);