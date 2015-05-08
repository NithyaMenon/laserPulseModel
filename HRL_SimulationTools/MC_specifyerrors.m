% MC_specifyerrors.m - Script to declare all of the component errors before
% running a Monte Carlo model

global ErrorSpecs

% Errors are fractions of nomial values unless otherwise specified
% These are all std deviations

% These errors are std deviations (unless otherwise specified) where the
% mean of the distribution is specified in the simulink model. The Monte
% Carlo model uses a random number generator to add on the error:
% Beam splitter transmission coefficient example:
% actualTrans = idealTrans*(1*ErrorSpecs.BeamSplitter.TransRef*rand(1,1))

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

% Delay error changed to be 0.1% of delay length
ErrorSpecs.Delay.Amount = 0.001;

ErrorSpecs.Attenuator.AttnFactor = 0.01;

ErrorSpecs.BeamSplitter.TransRef = 0.01;
ErrorSpecs.BeamSplitter.Ghost = 0.01;
ErrorSpecs.BeamSplitter.Back = 0.01;



