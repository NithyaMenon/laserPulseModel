function idealOutput = idealPulse(T, n, power, delay)

uddTimes =(pi/(2*n+2):pi/(2*n+2):n*pi/(2*n+2))';
uddSequence = T*sin(uddTimes).^2;

idealOutput = [];


for i= 1: size(uddSequence),
    pulse = Pulse([uddSequence(i)]);
    idealOutput(i) = pulse.ID;
end
