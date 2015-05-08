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