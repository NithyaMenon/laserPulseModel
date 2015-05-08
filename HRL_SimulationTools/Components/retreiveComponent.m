function [ component ] = retreiveComponent( ComponentType, ComponentID )
%RETRIEVECOMPONENT Returns a component given the type and ID.
%   C = retreiveComponent( ComponentType, Component ID ) takes arguments
%    ComponentType, which is a string such as 'BeamSplitter', and Component
%    ID, which is the ID of the ComponentType asked for.
%   Accepted component types are:
%       'PockelsCell', 'Delay', 'LinearPolarizer', 'HalfWavePlate',
%       'BeamSplitter', 'BeamSplitterRotated', 'PolarizingBeamSplitter',
%       'Attenuator'
%   This method is used by S-functions such as component_s.
%   See also: instantiateComponent, component_s

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
    case 'BeamSplitterRotated'
        component = BeamSplitterRotated.getComponent(ComponentID);
    case 'PolarizingBeamSplitter'
        component = PolarizingBeamSplitter.getComponent(ComponentID);
    case 'Attenuator'
        component = Attenuator.getComponent(ComponentID);
end


end

