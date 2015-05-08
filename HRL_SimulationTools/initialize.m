paths;
clearAll;
MC_specifyerrors;

p = PulseArray();
p.addPulse(Pulse([]));

N = 6;
T = 2002e-9;

% The following global variables are looked to in component initialization
% Allow Variation
global montecarlo;
montecarlo = 0;

% Initialize SampledErrors
global SampledErrors;
SampledErrors = struct('PolarizingBeamSplitter',[],'PockelsCell',[],...
    'LinearPolarizer',[],'HalfWavePlate',[],'Delay',[],'BeamSplitter',[],...
    'BeamSplitterRotated',[],'Attenuator',[]);
% Can also use a pre-defined SampledErrors if re-simulating a Monte Carlo
% run, but using resimulateWithSampledErrors is recommended for this.

% Save Pulse State History
global savestatehistory;
savestatehistory = 1; % Significant speedup if turned off

% Vector of input pulse timings
num_pulses_start = T/13e-9 + 10;
timings = 0:13e-9:(num_pulses_start-1)*13e-9;

% Pulse sequence creation
inputsignal = zeros(length(timings)+100,1);

for i = 1:length(timings)
    pulse1 = Pulse([timings(i)]);
    pA = PulseArray();clc
    pA.addPulse(pulse1);
    
    inputsignal(i) = pA.ID; % inputsignal is a vector of PulseArray IDs,
    % which are the data propegated through Simulink channels.
end


