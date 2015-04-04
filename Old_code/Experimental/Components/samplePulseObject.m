classdef samplePulseObject < handle
    %UNTITLED11 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties 
        % Sampled Pulse Parameters
        I;
        Q;
        U;
        V;
        time;
        width;
        PulseID;
        
        % samplePulseObject parameters
        ID;
    end
    
    methods
        function obj = samplePulseObject( pulseToSample )
            id = samplePulseObject.managesamplePulseObjectArray(obj, 'add');
            obj.ID = id;
            
            obj.I = pulseToSample.I;
            obj.Q = pulseToSample.Q;
            obj.U = pulseToSample.U;
            obj.V = pulseToSample.V;
            obj.time = pulseToSample.time;
            obj.width = pulseToSample.width;
            obj.PulseID = pulseToSample.ID;
            
            
        end
        function [I,Q,U,V,time,width] = getParams(obj)
            I = obj.I;
            Q = obj.Q;
            U = obj.U;
            V = obj.V;
            time = obj.time;
            width = obj.width;
        end
    end
    methods( Static = true, Access = 'private')
        function result = managesamplePulseObjectArray( samplePulseObject, operation)
            persistent samplePulseObjectarray
            persistent id;
            switch operation
                case 'add'
                    if(isempty(samplePulseObjectarray))
                        samplePulseObjectarray = [samplePulseObject];
                        id = 1;
                        result = id;
                    else
                        id = id+1;
                        samplePulseObjectarray(id) = samplePulseObject;
                        result = id;
                    end
                case 'getArray'
                    result = samplePulseObjectarray; % RETURNS A COPY. USE SET TO ALTER.
                case 'getsamplePulseObject'
                    result = samplePulseObjectarray(samplePulseObject); % samplePulseObject is id here
                case 'clear'
                    samplePulseObjectarray = [];
                    id = 0;
                    result = 1;
            end
        end
        
    end
    methods(Static)
        function samplePulseObjectArray =  getsamplePulseObjectArray()
            samplePulseObjectArray = samplePulseObject.managesamplePulseObjectArray([], 'getArray');
        end
        function samplePulseObjectArray =  clearsamplePulseObjects()
            samplePulseObjectArray = samplePulseObject.managesamplePulseObjectArray([], 'clear');
        end
        function samplePulseObjectArray = clearsamplePulseObjectArray()
            samplePulseObjectArray = samplePulseObject.managesamplePulseObjectArray('clear');
        end
        function outsamplePulseObject = getsamplePulseObject(id)
            outsamplePulseObject = samplePulseObject.managesamplePulseObjectArray(id, 'getsamplePulseObject');
        end
        
        function outsamplePulseObject = clonesamplePulseObject(insamplePulseObject)
            outsamplePulseObject = samplePulseObject([insamplePulseObject.time,insamplePulseObject.I,...
                insamplePulseObject.Q,insamplePulseObject.U,insamplePulseObject.V,insamplePulseObject.width]);
            outsamplePulseObject.stateHistoryArray = insamplePulseObject.stateHistoryArray;
           
        end
        function saveStateHistory(samplePulseObject,state_creator)
            samplePulseObject.stateHistoryArray = [samplePulseObject.stateHistoryArray, StateHistory(samplePulseObject,state_creator)];
        end
       
    end
    
end

