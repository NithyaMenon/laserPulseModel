
%% Clear Objects
Pulse.clearPulses();
PulseArray.clearComponent();
samplePulseObject.clearsamplePulseObjects();
PockelsCell.clearComponent();
Delay.clearComponent();
LinearPolarizer.clearComponent();
HalfWavePlate.clearComponent();
BeamSplitter.clearComponent();
BeamSplitterRotated.clearComponent();
PolarizingBeamSplitter.clearComponent();
Attenuator.clearComponent();


p = PulseArray();
p.addPulse(Pulse([]));

% Allow Variation (1)
global montecarlo;
montecarlo = 1;

% Initialize SampledErrors
global SampledErrors;
SampledErrors = struct('PolarizingBeamSplitter',[],'PockelsCell',[],...
    'LinearPolarizer',[],'HalfWavePlate',[],'Delay',[],'BeamSplitter',[],...
    'BeamSplitterRotated',[],'Attenuator',[]);

% Dont use a specified SampledErrors
global UseGivenErrors;
UseGivenErrors = 0;

% Dont save State History (1)
global savestatehistory;
savestatehistory = 0;

% Vector of input pulse timings
num_pulses_start = T/13e-9 + 10;
timings = 0:13e-9:(num_pulses_start-1)*13e-9;

% Pulse sequence creation
inputsignal = zeros(length(timings)+100,1);

for i = 1:length(timings)
    pulse1 = Pulse([timings(i)]);
    pA = PulseArray();
    pA.addPulse(pulse1);
    
    inputsignal(i) = pA.ID;
end


