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

out = [0; base(2); base(3); base(4); base(4)+base(2); base(4)+base(3)]+...
    ones(6,1)*base(1);
