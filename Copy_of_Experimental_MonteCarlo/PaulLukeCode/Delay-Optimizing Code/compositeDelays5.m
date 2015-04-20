function out = compositeDelays5(base)
% generates the possible composite delays of the optical network from the
% input tunable delays
%
% Input:
%  base - a vector of tunable delays
%
% Output:
%  Currently, the function computes twelve different composite delays from
%  five input delays. The first is an offset, and the other four are
%  permuted. Four of the sixteen permutations are eliminated due to the need
%  for the design to produce pi/2 pulses at appropriate times. The
%  remainder:
%               x1+x2                      x1
%               x1+x2+x3                   x1+x3
%               x1+x2+x5                   x1+x5
%               x1+x2+x3+x5                x1+x3+x5
%               x1+x2+x4+x5                x1+x4+x5
%               x1+x2+x3+x4+x5             x1+x3+x4+x5

out = [0; base(2); base(3); base(5); base(2)+base(3); base(2)+base(5);...
    base(3)+base(5); base(4)+base(5); base(2)+base(3)+base(5); ...
    base(2)+base(4)+base(5); base(3)+base(4)+base(5);...
    base(2)+base(3)+base(4)+base(5)] + ones(12,1)*base(1);
