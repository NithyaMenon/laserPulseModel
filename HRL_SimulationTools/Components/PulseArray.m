classdef PulseArray < handle
    %PULSEARRAY Container for pulses that can be referenced by ID.
    %   P = PulseArray() returns an empty pulse array P.
    %   result = P.addPulse(pulse) adds the Pulse 'pulse' and returns 1 if 
    %    the argument is a Pulse object, else returns -1.
    %   result = P.addPulsesFromPulseArray(pA) adds the Pulse objects from
    %    PulseArray pA to its own array.
    %   result = P.Empty() returns 1 if P is empty (holds no Pulses).
    %   result = P.clearArray() clears references to the Pulses held by P.
    %   P = PulseArray.getComponent(ID) returns PulseArray P that has the
    %    ID specified by argument 'ID'.
    %   pulse = PulseArray.getPulses(pA) returns an array of Pulses held by
    %    PulseArray 'pA'.
    %   result = PulseArray.addPulseTopA(pAid, pulse) adds the Pulse
    %    specified by pulse to the PulseArray specified by the ID 'pAid'.
    %    Returns 1 if successful.
    %   
    %
    %   This class is used to pass around multiple Pulses through
    %   Simulink's data channels with the use of only one number, which is
    %   the PulseArray's ID.
    %
    %   See also: Pulse, component_s
    
    properties
        ID;
        
        Array = [];
        
    end
    
    methods
        function obj = PulseArray()
            obj.ID = PulseArray.manageComponentArray(obj,'add');
            obj.Array = [];
        end
        function result = addPulse(obj,pulse)
            if(isa(pulse,'Pulse'))
                obj.Array = [obj.Array,pulse]; % Inefficent, but never expcted
                  % to be large number of pulses in a single PulseArray.
                result = 1;
            else
                result = -1;
            end
        end
        function result = addPulsesFromPulseArray(obj, pA)
            obj.Array = [obj.Array,pA.Array];
            result = 1;
        end
        function res = Empty(obj)
            res = isempty(obj.Array);
        end
        function res = clearArray(obj)
            obj.Array = [];
            res = 1;
        end
        
    end
    methods( Static )
        function result = manageComponentArray( cObj, operation)
            persistent componentarray
            persistent id;
            switch operation
                case 'add'
                    if(isempty(componentarray))
                        componentarray = [cObj];
                        id = 1;
                        result = id;
                    else
                        id = id+1;
                        componentarray(id) = cObj;
                        result = id;
                    end
                case 'getArray'
                    result = componentarray; % RETURNS A COPY. USE SET TO ALTER.
                case 'getComponent'
                    result = componentarray(cObj); % pulse is id here
                case 'clear'
                    componentarray = [];
                    id = 0;
                    result = 1;
            end
        end
  
        function componentArray =  getComponentArray()
            componentArray = PulseArray.manageComponentArray([], 'getArray');
        end
        function componentArray =  clearComponent()
            componentArray = PulseArray.manageComponentArray([], 'clear');
        end
        function componentArray = clearComponentArray()
            componentArray = PulseArray.manageComponentArray('clear');
        end
        function comp = getComponent(id)
            if(id>0)
                comp = PulseArray.manageComponentArray(id, 'getComponent');
            else
                comp = -1;
            end
            
        end
        function pulses = getPulses(id)
            if(id>0)
                pA = PulseArray.getComponent(id);
                pulses = pA.Array;
            else
                pulses = [];
            end
        end
        function res = addPulseTopA(pAid,pulse)
            pA = PulseArray.getComponent(pAid);
            pA.addPulse(pulse);
            res = 1;
        end

    end
    
end

