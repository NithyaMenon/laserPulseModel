function idealOutput = idealPulse(T, n, power)

fs = 800E8;    
t = 0 : 1/fs : T;
w = 2*10^(-9);

idealOutput = zeros(size(t));

uddTimes =(pi/(2*n+2):pi/(2*n+2):n*pi/(2*n+2))';
uddSequence = T*sin(uddTimes).^2;

for i= 1: size(uddSequence),
    timeOn = uddSequence(i);
    timeOnIndex = round(timeOn / (1/fs));
    timeOffIndex = round((timeOn + w)/ (1/fs));
    idealOutput(timeOnIndex:timeOffIndex) = 1 / power;
end

plot(t, idealOutput);