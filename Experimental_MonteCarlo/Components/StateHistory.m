classdef StateHistory<handle
    %STATEHISTORY Holds state of a pulse
    %   StateHistory returns an object that hold the properties of the
    %   input pulse when the StateHistory object is created. It also holds
    %   information regarding the process which induced the state
    %   (state_creator). The usage is: stateHistoryObj =
    %   StateHistory(inputPulse, state_creator), where state_creator is a
    %   string describing the creation of the state.
    %   
    %   See also: Pulse
    
    properties
        state_creator;
        % Stokes Parameters
        I;
        Q;
        U;
        V;
        % Pulse parameters
        time;
        width;
        ID;
       
    end
    
    methods
        function obj = StateHistory(pulse,st_creator)
            obj.state_creator = st_creator;
            obj.I = pulse.I;
            obj.Q = pulse.Q;
            obj.U = pulse.U;
            obj.V = pulse.V;
            obj.time = pulse.time;
            obj.width = pulse.width;
            obj.ID = pulse.ID;
            
        end
    end
    
end

