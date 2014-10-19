% 2T = 264 ns 
% 2 tau = 1 ns
two_T = 264*10^-9;
two_tau = 1*10^-9;

inputPulse = [75.76*10^6, 10, 0, 0];


stage1 = wireModule(inputPulse, 0.10);
[transmit, reflected] = beamSplitterModule(stage1, .5);

stage2Trans = wireModule(transmit, 0.20);
stage2Trans = pulseSelectModule(stage2Trans, two_T/2, 10);
% stage2Trans = delayModule(stage2Trans, 33.01*10^(-9));


stage2Refl = wireModule(reflected, 0.30);
stage2Refl = pulseSelectModule(stage2Refl, two_T/2, 19);
stage2Refl = attenuateModule(stage2Refl, 0.5);
stage2Refl = delayModule(stage2Refl, two_tau/2);

fs = 800E8;    
t = 0 : 1/fs : two_T;


x = pulseSequenceDisplay(inputPulse, two_T);
y = pulseSequenceDisplay(stage2Trans, two_T);
z = pulseSequenceDisplay(stage2Refl, two_T);

figure(1)
subplot(3,1,1)
plot(t*1E9, x)
subplot(3,1,2)
plot(t*1E9, y)
subplot(3,1,3)
plot(t*1E9, z);



stage3 = beamCombineModule([stage2Trans; stage2Refl], .5, two_T);
w = pulseSequenceDisplay(stage3, two_T);
figure(2)
plot(t*1E9, w);
