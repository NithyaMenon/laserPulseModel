function idealOutput = idealPulse(T, n, power, delay)

fs = 800E8;    
t = 0 : 1/fs : T;
w = 2*10^(-9);

T2 = 1.5*10^(-6);
t2 = 0 : 1/fs : T2;
idealOutput = zeros(size(t2));

uddTimes =(pi/(2*n+2):pi/(2*n+2):n*pi/(2*n+2))';
uddSequence = T*sin(uddTimes).^2;

for i= 1: size(uddSequence),
    timeOn = uddSequence(i) + delay;
    timeOnIndex = round(timeOn / (1/fs));
    timeOffIndex = round((timeOn + w)/ (1/fs));
    idealOutput(timeOnIndex:timeOffIndex) = 1 / power;
end

idealOutput = [ t2' idealOutput'];