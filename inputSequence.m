function outputSequence = inputSequence( repRate, power, offset, totalTime)

% create a [N x 3] matrix  where each row contains [t, power_Vertical, power_H]
% pulses default to 100% vertical

fs = 800E8;    
t = 0 : 1/fs : totalTime;
w = .5*10^(-9);
inputPeriod = 1/repRate;

D = offset : inputPeriod : totalTime; 

pulseTrain = pulstran(t, D, @rectpuls,w);

pulseTrain = power*pulseTrain;

horiz_amp = zeros(size(t));



outputSequence = [ t' pulseTrain' horiz_amp'];

    
end

