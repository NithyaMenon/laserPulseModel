classdef Pulse < handle
    %UNTITLED11 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        time;
        verticalPower;
        horizontalPower;
        width;
        DeadPulse;
        ID;
    end
    
    methods
        function obj = Pulse( inputArgs )
            switch length(inputArgs)
                case 0
                    obj.time = 0; % Standard 0 s start time
                    obj.verticalPower = 0.75; % Standard 750 mW power in vertical polarization.
                    obj.horizontalPower = 0.75; % Standard 750 mW power in vertical polarization.
                    obj.width = 5e-12; % Standard 5 ps width
                case 1
                    obj.time = inputArgs(1); % Standard 0 s start time
                    obj.verticalPower = 0.75; % Standard 750 mW power in vertical polarization.
                    obj.horizontalPower = 0.75; % Standard 750 mW power in vertical polarization.
                    obj.width = 5e-12; % Standard 5 ps width
                case 2
                    obj.time = inputArgs(1); % Standard 0 s start time
                    obj.verticalPower = inputArgs(2); % Standard 750 mW power in vertical polarization.
                    obj.horizontalPower = 0.75; % Standard 750 mW power in vertical polarization.
                    obj.width = 5e-12; % Standard 5 ps width
                case 3
                    obj.time = inputArgs(1); % Standard 0 s start time
                    obj.verticalPower = inputArgs(2); % Standard 750 mW power in vertical polarization.
                    obj.horizontalPower = inputArgs(3); % Standard 750 mW power in vertical polarization.
                    obj.width = 5e-12; % Standard 5 ps width
                otherwise
                    obj.time = inputArgs(1); % Standard 0 s start time
                    obj.verticalPower = inputArgs(2); % Standard 750 mW power in vertical polarization.
                    obj.horizontalPower = inputArgs(3); % Standard 750 mW power in vertical polarization.
                    obj.width = inputArgs(4); % Standard 5 ps width
            end
            id = Pulse.managePulseArray(obj, 'add');
            obj.ID = id;
            obj.DeadPulse = 0;
        end
    end
    methods( Static = true, Access = 'private')
        function result = managePulseArray( pulse, operation)
            persistent pulsearray
            persistent id;
            switch operation
                case 'add'
                    if(isempty(pulsearray))
                        pulsearray = [pulse];
                        id = 1;
                        result = id;
                    else
                        id = id+1;
                        pulsearray(id) = pulse;
                        result = id;
                    end
                case 'getArray'
                    result = pulsearray; % RETURNS A COPY. USE SET TO ALTER.
                case 'getPulse'
                    result = pulsearray(pulse); % pulse is id here
                case 'clear'
                    pulsearray = [];
                    id = 0;
                    result = 1;
            end
        end
    end
    methods(Static)
        function pulseArray =  getPulseArray()
            pulseArray = Pulse.managePulseArray([], 'getArray');
        end
        function pulseArray =  clearPulses()
            pulseArray = Pulse.managePulseArray([], 'clear');
        end
        function pulseArray = clearPulseArray()
            pulseArray = Pulse.managePulseArray('clear');
        end
        function pulse = getPulse(id)
            pulse = Pulse.managePulseArray(id, 'getPulse');
        end
        function killPulse(id)
            if(id==0)
                return
            end
            p1 = Pulse.getPulse(id);
            p1.DeadPulse = 1;
        end
        function pulseArray = getLivePulseArray()
            pulses = Pulse.getPulseArray();
            pulseArray = [];
            for i = 1:length(pulses);
                p = pulses(i);
                if(p.DeadPulse ~= 1)
                    pulseArray = [pulseArray,p];
                end
            end
        end
    end
    
end

