global ErrorSpecs

% Errors are fractions of nomial values unless otherwise specified
% These are all std deviations

ErrorSpecs.Pulse.Time = 0.01e-9; % This is an absolute error
ErrorSpecs.Pulse.I = 0.01;

ErrorSpecs.PolarizingBeamSplitter.TransRef = 0.01; % Ex. This means 1% of 0.5 avg transmission
ErrorSpecs.PolarizingBeamSplitter.Ghost = 0.01;
ErrorSpecs.PolarizingBeamSplitter.Psi = 0.01;
ErrorSpecs.PolarizingBeamSplitter.Back = 0.01;

ErrorSpecs.PockelsCell.Psi = 0.01;
ErrorSpecs.PockelsCell.Transmission = 0.01;
ErrorSpecs.PockelsCell.SCurve = 2.5*pi/180; % This is an absolute error

ErrorSpecs.LinearPolarizer.Psi = 0.01;
ErrorSpecs.LinearPolarizer.Transmission = 0.01;

ErrorSpecs.HalfWavePlate.Tau = 0.01;
ErrorSpecs.HalfWavePlate.Transmission = 0.001;
ErrorSpecs.HalfWavePlate.Psi = 0.01;

ErrorSpecs.Delay.Amount = 0.01;

ErrorSpecs.BeamSplitter.TransRef = 0.01;
ErrorSpecs.BeamSplitter.Ghost = 0.01;
ErrorSpecs.BeamSplitter.Back = 0.01;



