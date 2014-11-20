function out = uddTimes(T,n,plot)
% computes and displays a sin^2 sequence. If plot=1, plot will be
% displayed.
%
% Inputs:
%  T - the overall length of the UDD sequence to be approximated, in
%      nanoseconds
%  n - the number of pi pulses in the UDD sequence
%  plot - optional boolean input to turn off plotting
%
% Outputs:
%  Computes the pi pulse arrival times of a UDD sequence of length T and
%  order n. The timings can be plotted on an arc by setting plot = 1.

if nargin < 3
    plot = false;
end

t = (pi/(2*n+2):pi/(2*n+2):n*pi/(2*n+2))';

out = T*sin(t).^2;

if plot
    t2 = (0:T/100:T)';
    circle = @(t) sqrt(T^2/4-(t-T/2).^2);

    plot(t2,circle(t2));
    hold on;

    for i = 1:n
        plot([out(i) out(i)],[0 circle(out(i))]);
    end
    axis equal;
    hold off;
end
