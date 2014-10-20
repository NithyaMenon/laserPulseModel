fs = 100E9;                % sample freq 100GHz
D = [2.5 10 17.5]' * 1e-9; % pulse delay times
F = [ 6 13 20]' * 1e-9;
t = 0 : 1/fs : 25e-9;      % time 0-25ns
w = 1e-9;                  % width of each pulse
yp = pulstran(t,D,@rectpuls,w);
yp2 = pulstran(t,F,@rectpuls,w);
yp3 = yp+yp2;
plot(t*1e9,yp3);
x = max(yp3);