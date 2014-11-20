function out = uddTimes(T,n,plot)
% computes and displays a sin^2 sequence. If plot=1, plot will be
% displayed.

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
