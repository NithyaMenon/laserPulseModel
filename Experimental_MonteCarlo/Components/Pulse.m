classdef Pulse < handle
    %PULSE Object 
    %   The pulse object can be called with the following example piece of
    %   code: p1 = Pulse([time,I,Q,U,V,width]) . The if not all arguments
    %   are passed, default values will be assigned. 
    %
    %   Argument Descriptions:
    %    time - pulse creation time (default = 0 ns)
    %    I - intensitiy of pulse (default = 1 W)
    %    Q,U,V - polarization parameters. (default = 0,0,0 (unpolarized))
    %      See http://en.wikipedia.org/wiki/Stokes_parameters
    %    width - pulse width (default = 5 ps)
    %
    %   Relevant Static Methods:
    %     Pulse.getPulse(pulseID) - returns pulse object handle for
    %         specified ID.
    %     Pulse.saveStateHistory(pulse,state_creator) - appends a
    %         StateHistory object labelled with the state creator to the 
    %         pulse's state history array.
    %     Pulse.printStateHistory(pulse or pulseID) - prints to command
    %         window the StateHistory objects assigned to a pulse.
    %     Pulse.clonePulse(inputPulse) - returns a new pulse with the same
    %         properties as the input pulse.
    %     Pulse.clearPulses() - clears references from the Pulse object's
    %         static fields. Should be used at the start of any simulation.
    
    properties 
        % Stokes Parameters
        I;
        Q;
        U;
        V;
        % Pulse parameters
        time;
        width;
        ID;
        stateHistoryArray = [];
    end
    
    methods
        function obj = Pulse( inputArgs )
            id = Pulse.managePulseArray(obj, 'add');
            obj.ID = id;
            
            % Hard-coded Jitter: From pulse source
            global montecarlo; % Will cause jitter on time and power
            
            Isd = 0.01; % W
            timesd = 0.1e-9; % s
            
            
            
            switch length(inputArgs)
                case 0
                    obj.time = 0 + montecarlo*timesd*randn(1,1); % Standard 0 s start time
                    obj.I = 1 + montecarlo*Isd*randn(1,1); % Standard 1 W intensity.
                    obj.Q = 0; % Standard no polarization
                    obj.U = 0;
                    obj.V = 0;
                    obj.width = 5e-12; % Standard 5 ps width
                case 1
                    obj.time = inputArgs(1);
                    obj.I = 1 + montecarlo*Isd*randn(1,1); % Standard 1 W intensity.
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
            obj.stateHistoryArray = [obj.stateHistoryArray,...
                StateHistory(obj,'creation')];
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
        
        function outPulse = clonePulse(inPulse)
            outPulse = Pulse([inPulse.time,inPulse.I,...
                inPulse.Q,inPulse.U,inPulse.V,inPulse.width]);
            outPulse.stateHistoryArray = inPulse.stateHistoryArray;
           
        end
        function saveStateHistory(pulse,state_creator)
            global savestatehistory;
            if(savestatehistory)
                pulse.stateHistoryArray = [pulse.stateHistoryArray, StateHistory(pulse,state_creator)];
            end
        end
        function printStateHistory(input)
            if(~isa(input,'Pulse'))
                input = Pulse.getPulse(input);
            end
            sHArray = input.stateHistoryArray;
            for i = 1:length(sHArray)
                display(sHArray(i))
            end
        end
        function result = wasAeverB(pulseAID,pulseBID)
            pulseA = Pulse.getPulse(pulseAID);
            pulseB = Pulse.getPulse(pulseBID);
            sh = pulseA.stateHistoryArray;
            result = 0;
            for p = sh
                if(pulseB.ID == p.ID)
                    result =  1;
                end
            end
        end
    end
    
end

