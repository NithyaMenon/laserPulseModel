classdef StateHistory<handle
    %STATEHISTORY Holds state of a pulse
    %   Detailed explanation goes here
    
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

