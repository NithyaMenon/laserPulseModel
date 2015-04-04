function [ Pulses, Is, Qs, Us, Vs, widths, times, IDs] = ProcessSimout(simout)

    sout = zeros(length(simout.Data),1);
    for i = 1:length(sout)
        sout(i) = simout.Data(:,:,i);
    end

    Pulses = [];
    for i = 1:length(sout)

        s = sout(i);
        Pulses = [Pulses,PulseArray.getPulses(s)];
    end

    Is = ones(size(Pulses));
    Qs = ones(size(Pulses));
    Us = ones(size(Pulses));
    Vs = ones(size(Pulses));
    widths = ones(size(Pulses));
    times = ones(size(Pulses));
    IDs = ones(size(Pulses));

    for i = 1:length(Pulses)
        Is(i) = Pulses(i).I;
        Qs(i) = Pulses(i).Q;
        Us(i) = Pulses(i).U;
        Vs(i) = Pulses(i).V;
        widths(i) = Pulses(i).width;
        times(i) = Pulses(i).time;
        IDs(i) = Pulses(i).ID;
    end
    
    [~,Inds] = sort(times);
    Pulses = Pulses(Inds);
    Is = Is(Inds);
    Qs = Qs(Inds);
    Us = Us(Inds);
    Vs = Vs(Inds);
    widths = widths(Inds);
    times = times(Inds);
    IDs = IDs(Inds);
end