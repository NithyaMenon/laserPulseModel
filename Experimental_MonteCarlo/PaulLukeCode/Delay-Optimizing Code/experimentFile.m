function [compDels, conFun, nDelays] = experimentFile()
% user-generated file that is customized for each experimental setup

compDels = @compositeDelays;
conFun = @constraintFunction;
nDelays = 2;
end


function out = compositeDelays(base)
% generates the possible composite delays of the optical network from the
% input tunable delays
%
% Input:
%  base - a vector of tunable delays
%
% Output:
%  Currently, the function computes six different composite delays from
%  four input delays. The first is an offset, and the other three are
%  permuted. Two of the eight permutations are eliminated due to the need
%  for the design to produce pi/2 pulses at appropriate times. The
%  remainder:
%               x1
%               x1+x2
%               x1+x3
%               x1+x4
%               x1+x4+x2
%               x1+x4+x3

out = [0;base(1);base(2)];
end


function [A,B,Aeq,Beq,lb,ub] = constraintFunction()
% helper function for digOp.m that creates constraints for fmincon
%
% Inputs: none
%
% Outputs:
%  constraintFunction

A = [1 -1];
B = [0];
Aeq = [];
Beq = [];
lb = zeros(2,1);
ub = ones(2,1);
end