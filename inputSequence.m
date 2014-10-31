function outputSequence = inputSequence( repRate, power, offset, polarization, totalTime)

% create a [N x 3] matrix  where each row contains [t, power, polarization]

fs = 800E8;    
t = 0 : 1/fs : totalTime;
w = 3*10^(-9);
inputPeriod = 1/repRate;

D = offset : inputPeriod : totalTime; 

pulseTrain = pulstran(t, D, @rectpuls,w);

pulseTrain = power*pulseTrain;

pols = zeros(size(t));
pols(:)=polarization;


outputSequence = [ t' pulseTrain' pols'];

    
end

