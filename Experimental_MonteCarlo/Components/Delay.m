classdef Delay < Component
    %UNTITLED5 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ID;
        
        LeftInputStream;
        RightInputStream;
        LeftOutputStream;
        RightOutputStream;
        
        % Component Specific Params
        DelayAmt;
        
    end
    
    methods
        function obj = Delay(DelayAmt)
            id = Delay.manageComponentArray(obj, 'add');
            obj.ID = id;
            
            global montecarlo;
            global ErrorSpecs;
            global UseGivenErrors;
            global SampledErrors;
            
            if (UseGivenErrors == 1);
                problem = 1;
                for s = SampledErrors.Delay
                    if(s.ID == obj.ID)
                        obj.DelayAmt = s.Amount;
                        problem = 0;
                        break;
                    end
                end
                if(problem)
                    display('ERROR: Object not specified by SampledErrors');
                end
            else
                DelayAmtsd = ErrorSpecs.Delay.Amount; % Hard-coded component jitter

                obj.DelayAmt = DelayAmt*(1 + montecarlo*DelayAmtsd*randn(1,1));

                se = struct('ID',obj.ID,'Amount',obj.DelayAmt);
                SampledErrors.Delay =...
                    [SampledErrors.Delay, se];
            end
            
            streamSize = 5000; % For Preallocation
            obj.LeftInputStream = StreamArray(streamSize);
            obj.RightInputStream = StreamArray(streamSize);
            obj.LeftOutputStream = StreamArray(streamSize);
            obj.RightOutputStream = StreamArray(streamSize);
            
        end
        function result = apply(obj,pulseArrayIDs)
            leftPulses = PulseArray.getPulses(pulseArrayIDs(1));
            rightPulses = PulseArray.getPulses(pulseArrayIDs(2));
            for p = leftPulses
                obj.LeftInputStream.add(p);
                obj.action(p);
                obj.LeftOutputStream.add(p);
                
            end
            for p = rightPulses
                obj.RightInputStream.add(p);
                obj.action(p);
                obj.RightOutputStream.add(p);
                
            end
            result = pulseArrayIDs;
        end
        function result = action(obj,inputPulse)
            
            resultPulse = inputPulse;
            resultPulse.time = resultPulse.time + obj.DelayAmt;
            
            
            state_creator = sprintf('Delay %i: DelayAmt = %0.2f ns',...
                obj.ID,obj.DelayAmt*1e9);
            Pulse.saveStateHistory(resultPulse,state_creator);
            
            result = 1;
        end
        function [Times,Is,Qs,Us,Vs,Widths,IDs] = streamData(~,stream)
            
            [Times,Is,Qs,Us,Vs,Widths,IDs] = StreamArray.StreamData(stream);
            
            [Times,Inds] = sort(Times);
            Is = Is(Inds);
            Qs = Qs(Inds);
            Us = Us(Inds);
            Vs = Vs(Inds);
            Widths = Widths(Inds);
            IDs = IDs(Inds);
            
        end
        function numCollisions = checkInterference(obj,importantPulses)
            [Times,Is,~,~,~,Widths,IDs] = obj.streamData([obj.LeftInputStream,obj.RightInputStream]);
            [Times,Inds] = sort(Times);
            IDs = IDs(Inds);
            Widths = Widths(Inds);
            Is = Is(Inds);
            dTimes = diff(Times);
            dWidths = (Widths(1:end-1) + Widths(2:end))/2;
            dLogPowers = abs(log10(Is(1:end-1)) - log10(Is(2:end)));
            Interferes = dTimes<dWidths & dLogPowers < 3; % Interference, of pulses than can affect eachother, that we actually care about.
            firstIDs = IDs([Interferes;logical(0)]);
            secondIDs = IDs([logical(0);Interferes]);
            firstIDmatches = [];
            secondIDmatches = [];
            for i = 1:length(firstIDs)
                for j = 1:length(importantPulses)
                    if(Pulse.wasAeverB(importantPulses(j),firstIDs(i)))
                        firstIDmatches = [firstIDmatches,[firstIDs(i);secondIDs(i)]];
                    end
                    if(Pulse.wasAeverB(importantPulses(j),secondIDs(i)))
                        secondIDmatches = [secondIDmatches,[firstIDs(i);secondIDs(i)]];
                    end
                end
            end
            numCollisions = size(firstIDmatches,2) + size(secondIDmatches,2);
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
            componentArray = Delay.manageComponentArray([], 'getArray');
        end
        function componentArray =  clearComponent()
            componentArray = Delay.manageComponentArray([], 'clear');
        end
        function componentArray = clearComponentArray()
            componentArray = Delay.manageComponentArray('clear');
        end
        function comp = getComponent(id)
            comp = Delay.manageComponentArray(id, 'getComponent');
        end
    end
    
end

