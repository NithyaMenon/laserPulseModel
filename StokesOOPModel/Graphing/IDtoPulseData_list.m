function [ times,I,Q,U,V,widths,IDs,StateHistoryArrays ] = IDtoPulseData_list( pulseIDs )
%IDTOPULSEDATA_LIST Summary of this function goes here
%   Detailed explanation goes here

pulseIDs = pulseIDs(pulseIDs~=0);
times = [];
I = [];
Q = [];
U = [];
V = [];
widths = [];
IDs = [];
StateHistoryArrays = [];

for i = pulseIDs
    p = Pulse.getPulse(i);
    times = [times, p.time];
    I = [I, p.I];
    Q = [ Q, p.Q];
    U = [ U, p.U];
    V = [ V, p.V];
    widths = [widths, p.width];
    IDs = [IDs, p.ID];
    StateHistoryArrays = [StateHistoryArrays, p.stateHistoryArray];
end

[~,inds] = sort(times);
times = times(inds);
I = I(inds);
Q = Q(inds);
U = U(inds);
V = V(inds);
widths = widths(inds);
IDs = IDs(inds);
StateHistoryArrays = StateHistoryArrays(inds);



end

