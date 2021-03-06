function [ td, pc1h, pc2h ] = ResimulateWithSampledErrors( SampledErrs, N, T )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    MC_specifyerrors;
    
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


    p = PulseArray();
    p.addPulse(Pulse([]));

    % Allow Variation (1)
    global montecarlo;
    montecarlo = 0;
    
    global SampledErrors;
    SampledErrors = SampledErrs;
    
    % Dont use a specified SampledErrors
    global UseGivenErrors;
    UseGivenErrors = 1;

    % Dont save State History (1)
    global savestatehistory;
    savestatehistory = 1;

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
    
    [PCTimings1,CP1,PCTimings2,CP2,DelayLeft,DelayMiddle,DelayBottom,optVal] = ...
            runExperiment(T*1e9,N);
    options = simset('SrcWorkspace','current');
    sim('MC_DigitizingDesign.slx',(T/13e-9)+50,options);

    [ Pulses, Is, Qs, Us, Vs, widths, times, IDs] = ProcessSimout(simout);

    NthLargestPulse = sort(Is);
    NthLargestPulse = NthLargestPulse(end-N-1); % N+2 for Pi/2 pulses, actually.

    ImportantPulses_Is = Is(Is>=NthLargestPulse-eps);
    ResidualPulses_Is = Is(Is<NthLargestPulse-eps);
    ImportantPulses_times = times(Is>=NthLargestPulse-eps);
    ResidualPulses_times = times(Is<NthLargestPulse-eps);
    OutputPlotting;
    PC1 = PockelsCell.getComponent(1);
    PC2 = PockelsCell.getComponent(2);
    pc1h = PC1.plotIO(T+50e-9);
    pc2h = PC2.plotIO(T+50e-9);




end

