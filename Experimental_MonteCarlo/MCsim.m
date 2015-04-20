function [Pulses, Is, Qs, Us, Vs, widths, times, IDs ] = MCsim( N, T, PCTimings1,CP1,PCTimings2,CP2,DelayLeft,DelayMiddle,DelayBottom,optVal )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    %% Initialize
    % Clear Objects
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


    p = PulseArray();
    p.addPulse(Pulse([]));

    % Allow Variation (1)
    global montecarlo;
    montecarlo = 1;

    % Initialize SampledErrors
    global SampledErrors;
    SampledErrors = struct('PolarizingBeamSplitter',[],'PockelsCell',[],...
        'LinearPolarizer',[],'HalfWavePlate',[],'Delay',[],'BeamSplitter',[],...
        'BeamSplitterRotated',[]);

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

    %% Simulate
    sim('MC_DigitizingDesign.slx',(T/13e-9)+50);

    [ Pulses, Is, Qs, Us, Vs, widths, times, IDs] = ProcessSimout(simout);


end

