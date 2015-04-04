classdef PulseArray < handle
    %UNTITLED5 Summary of this class goes here
    %   Detailed explanation goes here
    
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
                obj.Array = [obj.Array,pulse];
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

