paths;
clearAll;
MC_specifyerrors;

p = PulseArray();
p.addPulse(Pulse([]));

% Allow Variation (1)
global montecarlo;
montecarlo = 0;

% Initialize SampledErrors
global SampledErrors;
SampledErrors = struct('PolarizingBeamSplitter',[],'PockelsCell',[],...
    'LinearPolarizer',[],'HalfWavePlate',[],'Delay',[],'BeamSplitter',[],...
    'BeamSplitterRotated',[],'Attenuator',[]);

% Save State History (1)
global savestatehistory;
savestatehistory = 1;

% Vector of input pulse timings
num_pulses_start = 100;
timings = 0:13e-9:(num_pulses_start-1)*13e-9;

% Pulse sequence creation
inputsignal = zeros(length(timings)+100,1);

for i = 1:length(timings)
    pulse1 = Pulse([timings(i)]);
    pA = PulseArray();
    pA.addPulse(pulse1);
    
    inputsignal(i) = pA.ID;
end


