% laser pulse vector: 
%   [frequency(Hz), amplitude(?), offset(ns), polarization(0:vertical or 1:horizontal), power(fraction)]

% 2T = 264 ns 
% 2 tau = 1 ns

inputPulse = [75.76*10^6, 10, 0, 0, 1];
duration = 4*10^(-9);
%pulseSequenceDisplay(inputPulse, 900*10^(-9));

stage1 = wireModule(inputPulse, 0.10);
[transmit, reflected] = beamSplitterModule(stage1, .5);

stage2Trans = wireModule(transmit, 0.20);
stage2Trans = pulseSelectModule(stage2Trans, 9);
stage2Trans = delayModule(stage2Trans, 33.01*10^(-9));

%pulseSequenceDisplay(stage2Trans, 300*10^(-9))

stage2Refl = wireModule(reflected, 0.30);
stage2Refl = pulseSelectModule(stage2Refl, 4);
stage2Refl = attenuateModule(stage2Refl, 0.5);
%stage2Refl = delayModule(stage2Refl, 4*10^(-9));

stage3 = beamCombineModule([stage2Trans; stage2Refl], .5, 900*10^(-9));

pulseSequenceDisplay(stage3, 900*10^(-9));
