function out = uddTimes(T,n)
% computes and displays a sin^2 sequence

t = pi/(2*n+2):pi/(2*n+2):n*pi/(2*n+2);

out = T*sin(t).^2;

plot([0 0], [0 T]);
hold on;

for i = 1:n
    plot([out(i) out(i)],[0 T]);
end

plot([T T], [0 T]);
