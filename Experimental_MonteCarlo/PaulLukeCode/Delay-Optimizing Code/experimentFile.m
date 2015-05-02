function [compDels, conFun, nDelays] = experimentFile()
% user-generated file that is customized for each experimental setup
%
% Inputs:
%  None
%
% Outputs:
%  This is just a wrapper function to set the number of delays and pass two
%  function handles. nDelays is the number of independent, tunable delay
%  paths in the experiment.
%
% Last updated 5/2/15 by Paul Jerger.

    compDels = @compositeDelays;
    conFun = @constraintFunction;
    nDelays = 2;
end


function out = compositeDelays(x)
% generates the possible composite delays of the optical network from the
% input tunable delays
%
% Input:
%  x - a vector of the delay paths in the network
%
% Output:
%  This function generates all possible combinations of delays (i.e., the 
%  composite delays), as determined by the number and length of the delay
%  paths and the organization of the optical network.
%
%  Currently, there are only three total delay paths: one which is 
%  always zero relative delay and two that are entirely independent of the
%  first. This makes the composite delays trivial to compute from the delay
%  paths - simply return a vector of zero and the values of the other two
%  delays.

    out = [0;x(1);x(2)];
end


function [A,B,Aeq,Beq,lb,ub] = constraintFunction()
% helper function for delOp.m that creates constraints for fmincon
%
% Inputs: none
%
% Outputs:
%  constraintFunction holds the following information, which is
%  user-generated based on the construction of the optical network and the
%  desired details of the delay paths:
%
%   A & B: inequality constraints for fmincon; A*x < B
%   Aeq & Beq: equality constraints; Aeq*x = Beq
%   lb & ub: lower and upper bounds on the values of the delay paths, x,
%            which as a reminder has values that represent fractions of repRate

    A = [1 -1]; % specify that x(1) < x(2)
    B = 0;
    Aeq = [];
    Beq = [];
    lb = zeros(2,1);
    ub = ones(2,1);
end