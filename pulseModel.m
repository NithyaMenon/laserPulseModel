% laser pulse vector: 
%   [frequency(Hz), amplitude(?), offset(ns), polarization(0:vertical or 1:horizontal), power(fraction)]

% 2T = 264 ns 
% 2 tau = 1 ns

inputPulse = [75.76*10^6, 10, 0, 0];


stage1 = wireModule(inputPulse, 0.10);
[transmit, reflected] = beamSplitterModule(stage1, .5);

stage2Trans = wireModule(transmit, 0.20);
stage2Trans = pulseSelectModule(stage2Trans,0, 9);
stage2Trans = delayModule(stage2Trans, 33.01*10^(-9));


stage2Refl = wireModule(reflected, 0.30);
stage2Refl = pulseSelectModule(stage2Refl,0, 4);
stage2Refl = attenuateModule(stage2Refl, 0.5);
%stage2Refl = delayModule(stage2Refl, 4*10^(-9));

fs = 800E8;    
t = 0 : 1/fs : 400*10^(-9);


x = pulseSequenceDisplay(inputPulse, 400*10^(-9));
y = pulseSequenceDisplay(stage2Trans, 400*10^(-9));
z = pulseSequenceDisplay(stage2Refl, 400*10^(-9));

figure(1)
subplot(3,1,1)
plot(t*1E9, x)
subplot(3,1,2)
plot(t*1E9, y)
subplot(3,1,3)
plot(t*1E9, z);



stage3 = beamCombineModule([stage2Trans; stage2Refl], .5, 400*10^(-9));
w = pulseSequenceDisplay(stage3, 400*10^(-9));
figure(2)
plot(t*1E9, w);
