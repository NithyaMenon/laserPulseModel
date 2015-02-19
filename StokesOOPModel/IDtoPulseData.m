function [ times,I,Q,U,V,widths ] = IDtoPulseData( simout )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

u = simout.Data;

u = u(u~=0);

times = [];
I = [];
Q = [];
U = [];
V = [];
widths = [];

for i = u
    p = Pulse.getPulse(i);
    times = [times, p.time];
    I = [I, p.I];
    Q = [ Q, p.Q];
    U = [ U, p.U];
    V = [ V, p.V];
    widths = [widths, p.width];
end

[~,inds] = sort(times);
times = times(inds);
I = I(inds);
Q = Q(inds);
U = U(inds);
V = V(inds);
widths = widths(inds);



end

