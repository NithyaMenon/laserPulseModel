function [ component ] = retreiveComponent( ComponentType, ComponentID )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

switch ComponentType
    case 'PockelsCell'
        component = PockelsCell.getComponent(ComponentID);
    case 'Delay'
        component = Delay.getComponent(ComponentID);
    case 'LinearPolarizer'
        component = LinearPolarizer.getComponent(ComponentID);
    case 'HalfWavePlate'
        component = HalfWavePlate.getComponent(ComponentID);
    case 'BeamSplitter'
        component = BeamSplitter.getComponent(ComponentID);
    case 'PolarizingBeamSplitter'
        component = PolarizingBeamSplitter.getComponent(ComponentID);
end


end

