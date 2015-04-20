function [ component ] = instantiateComponent( ComponentType, ComponentParams )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

switch ComponentType
    case 'PockelsCell'
        component = PockelsCell(ComponentParams.PCTimings, ComponentParams.ControlPowers, ComponentParams.Psi);
    case 'Delay'
        component = Delay(ComponentParams.DelayAmt);
    case 'Attenuator'
        component = Attenuator(ComponentParams.AttnFactor);
    case 'LinearPolarizer'
        component = LinearPolarizer(ComponentParams.Psi, ComponentParams.Transmittence, ComponentParams.ExtinctionRatio);
    case 'HalfWavePlate'
        component = HalfWavePlate(ComponentParams.Psi, ComponentParams.Transmittence);
    case 'BeamSplitter'
        component = BeamSplitter(ComponentParams.Transmittance, ComponentParams.Reflectance,...
            ComponentParams.Ghost, ComponentParams.BackReflectance);
    case 'BeamSplitterRotated'
        component = BeamSplitterRotated(ComponentParams.Transmittance, ComponentParams.Reflectance,...
            ComponentParams.Ghost, ComponentParams.BackReflectance);
    case 'PolarizingBeamSplitter'
        component = PolarizingBeamSplitter(ComponentParams.Psi,ComponentParams.Transmittance, ComponentParams.Reflectance,...
            ComponentParams.Ghost, ComponentParams.BackReflectance);
        
end


end

