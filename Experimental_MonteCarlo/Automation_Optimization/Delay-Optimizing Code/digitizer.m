function tp = digitizer(pulses,Tmax,repRate,frac)
% adjusts a series of pulse timings, 'pulses', to the nearest repRate/frac,
% where repRate is a repeated pulse rate and frac is some fraction of that
% rate

digs = (0:repRate/frac:Tmax)';
inds = dsearchn(digs,pulses);
tp = zeros(length(pulses),1);

for j = 1:length(pulses)
    tp(j) = digs(inds(j));
end
