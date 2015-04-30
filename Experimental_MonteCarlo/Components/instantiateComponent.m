function [ component ] = instantiateComponent( ComponentType, ComponentParams )
%INSTANTIATECOMPONENT Returns a component given the type and parameters.
%   C = instantiateComponent( ComponentType, ComponentParams ) takes
%    arguments ComponentType, which is a string such as 'BeamSplitter', and
%    ComponentParams, which is a struct of parameters for ComponentType 
%    asked for.
%   Accepted component types and their required paramters are:
%       'PockelsCell' - PCTimings, ControlPowers, Psi
%       'Delay' - DelayAmt 
%       'Attenuator' - AttnFactor
%       'LinearPolarizer' - Psi, Transmittence, ExtinctionRatio
%       'HalfWavePlate' - Psi, Transmittence
%       'BeamSplitter' - Transmittance, Reflectance, Ghost, BackReflectance
%       'BeamSplitterRotated' - Same as BeamSplitter, 
%       'PolarizingBeamSplitter' - Psi, Same as BeamSplitter
%   
%   This method is used by S-functions such as component_s.
%   See also: retreiveComponent, component_s

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

