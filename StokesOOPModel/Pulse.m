classdef Pulse < handle
    %UNTITLED11 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties 
        % Stokes Parameters
        I;
        Q;
        U;
        V;
        % Pulse parameters
        time;
        width;
        DeadPulse;
        ID;
    end
    
    methods
        function obj = Pulse( inputArgs )
            switch length(inputArgs)
                case 0
                    obj.time = 0; % Standard 0 s start time
                    obj.I = 1; % Standard 1 W intensity.
                    obj.Q = 0; % Standard no polarization
                    obj.U = 0;
                    obj.V = 0;
                    obj.width = 5e-12; % Standard 5 ps width
                case 1
                    obj.time = inputArgs(1);
                    obj.I = 1; % Standard 1 W intensity.
                    obj.Q = 0; % Standard no polarization
                    obj.U = 0;
                    obj.V = 0;
                    obj.width = 5e-12; % Standard 5 ps width
                case 2
                    obj.time = inputArgs(1); 
                    obj.I = inputArgs(2);
                    obj.Q = 0; % Standard no polarization
                    obj.U = 0;
                    obj.V = 0;
                    obj.width = 5e-12; % Standard 5 ps width
                case 5
                    obj.time = inputArgs(1); 
                    obj.I = inputArgs(2);
                    obj.Q = inputArgs(3);
                    obj.U = inputArgs(4);
                    obj.V = inputArgs(5);
                    obj.width = 5e-12; % Standard 5 ps width
                case 6
                    obj.time = inputArgs(1); 
                    obj.I = inputArgs(2);
                    obj.Q = inputArgs(3);
                    obj.U = inputArgs(4);
                    obj.V = inputArgs(5);
                    obj.width = inputArgs(6); 
                otherwise
                    obj.time = 0; % Standard 0 s start time
                    obj.I = 1; % Standard 1 W intensity.
                    obj.Q = 0; % Standard no polarization
                    obj.U = 0;
                    obj.V = 0;
                    obj.width = 5e-12; % Standard 5 ps width
                    display('Invalid Pulse constructor for number of input arguments')
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
        function outPulse = clonePulse(inPulse)
            outPulse = Pulse([inPulse.time,inPulse.I,...
                inPulse.Q,inPulse.U,inPulse.V,inPulse.width]);
        end
    end
    
end

