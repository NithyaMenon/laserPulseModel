classdef PolarizingBeamSplitter < Component
    %UNTITLED5 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ID;
        
        TopInputStream;
        LeftInputStream;
        RightInputStream;
        BottomInputStream;
        TopOutputStream;
        LeftOutputStream;
        RightOutputStream;
        BottomOutputStream;
        
        % Component Specific Params
        Psi;
        Transmittance;
        Reflectance;
        Ghost;
        M_trans;
        M_ref;
        
        Cutoff_Power = 1e-10; % HardCoded
        
        
    end
    
    methods
        function obj = PolarizingBeamSplitter(Psi,Transmittance,Reflectance,Ghost)
            id = PolarizingBeamSplitter.manageComponentArray(obj, 'add');
            obj.ID = id;
            
            % Hard Coded Jitter
            global montecarlo;
            TransRefsd = 0.02;
            Ghostsd = 0.005;
            Psisd = pi*0.02;
            
            obj.Psi = Psi + montecarlo*Psisd*randn(1,1);
            obj.Reflectance = Reflectance + montecarlo*TransRefsd*randn(1,1);
            obj.Transmittance = Transmittance + montecarlo*TransRefsd*randn(1,1);
            obj.Ghost = Ghost + montecarlo*Ghostsd*randn(1,1);
            
            J_pass = [cos(Psi)^2, cos(Psi)*sin(Psi);...
                sin(Psi)*cos(Psi), sin(Psi)^2];
            A = [ 1 0 0 1;...
                1 0 0 -1;...
                0 1 1 0;...
                0 1i -1i 0];
            obj.M_trans = A*kron(J_pass,conj(J_pass))*inv(A);
            
            Psi_2 = Psi-pi/2;

            J_stop = [cos(Psi_2)^2, cos(Psi_2)*sin(Psi_2);...
                sin(Psi_2)*cos(Psi_2), sin(Psi_2)^2];

            % Compute Mueller Matrix
            A = [ 1 0 0 1;...
                1 0 0 -1;...
                0 1 1 0;...
                0 1i -1i 0];

            obj.M_ref = A*kron(J_stop,conj(J_stop))*inv(A);

            obj.TopInputStream = [];
            obj.LeftInputStream = [];
            obj.RightInputStream = [];
            obj.BottomInputStream = [];
            obj.TopOutputStream = [];
            obj.LeftOutputStream = [];
            obj.RightOutputStream = [];
            obj.BottomOutputStream = [];
            
        end
        function result = apply(obj,pulseArrayIDs)
            topPulses = PulseArray.getPulses(pulseArrayIDs(1));
            leftPulses = PulseArray.getPulses(pulseArrayIDs(2));
            rightPulses = PulseArray.getPulses(pulseArrayIDs(3));
            bottomPulses = PulseArray.getPulses(pulseArrayIDs(4));
            
            topOut = PulseArray();
            leftOut = PulseArray();
            rightOut = PulseArray();
            bottomOut = PulseArray();
            
            function addAPulse(outputLocation,pulse)
                if(pulse.I>obj.Cutoff_Power)
                    switch outputLocation
                        case 'Top'
                            obj.TopOutputStream = [obj.TopOutputStream,samplePulseObject(pulse)];
                            topOut.addPulse(pulse);
                        case 'Right'
                            obj.RightOutputStream = [obj.RightOutputStream,samplePulseObject(pulse)];
                            rightOut.addPulse(pulse);
                        case 'Left'
                            obj.LeftOutputStream = [obj.LeftOutputStream,samplePulseObject(pulse)];
                            leftOut.addPulse(pulse);
                        case 'Bottom'
                            obj.BottomOutputStream = [obj.BottomOutputStream,samplePulseObject(pulse)];
                            bottomOut.addPulse(pulse);
                    end
                end
            end
            
            for p = leftPulses
                obj.LeftInputStream = [obj.LeftInputStream,samplePulseObject(p)];
                [LT,LR,LG] = obj.action(p);
                addAPulse('Right',LT);
                addAPulse('Bottom',LG);
                addAPulse('Top',LR);
                
            end
            
            for p = topPulses
                obj.TopInputStream = [obj.TopInputStream,samplePulseObject(p)];
                [TT,TR,TG] = obj.action(p);
                addAPulse('Right',TG);
                addAPulse('Bottom',TT);
                addAPulse('Left',TR);
                
            end
            
            for p = bottomPulses
                obj.BottomInputStream = [obj.BottomInputStream,samplePulseObject(p)];
                [BT,BR,BG] = obj.action(p);
                addAPulse('Right',BR);
                addAPulse('Top',BT);
                addAPulse('Left',BG);
           
            end
            for p = rightPulses
                obj.RightInputStream = [obj.RightInputStream,samplePulseObject(p)];
                [RT,RR,RG] = obj.action(p);
                addAPulse('Top',RG);
                addAPulse('Bottom',RR);
                addAPulse('Left',RT);
                
            end
            
            result = [topOut.ID*~topOut.Empty(), leftOut.ID*~leftOut.Empty(),...
                rightOut.ID*~rightOut.Empty(), bottomOut.ID*~bottomOut.Empty()];
        end
        
        
        function [transmitPulse,reflectPulse,ghostPulse] = action(obj,inputPulse)
            
            transmitPulse = inputPulse;
            reflectPulse = Pulse.clonePulse(inputPulse);
            ghostPulse = Pulse.clonePulse(inputPulse);
            
            S = [inputPulse.I;inputPulse.Q;inputPulse.U;inputPulse.V];
            
            Sout = obj.Transmittance*(obj.M_trans)*S;
            
            transmitPulse.I = Sout(1);
            transmitPulse.Q = Sout(2);
            transmitPulse.U = Sout(3);
            transmitPulse.V = Sout(4);
            
            Sout = obj.Reflectance*(obj.M_ref)*S;
            
            reflectPulse.I = Sout(1);
            reflectPulse.Q = Sout(2);
            reflectPulse.U = Sout(3);
            reflectPulse.V = Sout(4);
            
            Sout = obj.Ghost*(obj.M_ref)*S;
            
            ghostPulse.I = Sout(1);
            ghostPulse.Q = Sout(2);
            ghostPulse.U = Sout(3);
            ghostPulse.V = Sout(4);
            
            
            
            %% State Saving
            
            state_creator = sprintf('PolarizingBeamSplitterTransmit %i',...
                obj.ID);
            Pulse.saveStateHistory(transmitPulse,state_creator);
            state_creator = sprintf('PolarizingBeamSplitterReflect %i',...
                obj.ID);
            Pulse.saveStateHistory(reflectPulse,state_creator);
            state_creator = sprintf('PolarizingBeamSplitterGhost %i',...
                obj.ID);
            Pulse.saveStateHistory(ghostPulse,state_creator);
        end
        function [Times,Is,Qs,Us,Vs,Widths,IDs] = streamData(obj,stream)
            
            Times = -ones(length(stream),1);
            Is = -ones(length(stream),1);
            Qs = -ones(length(stream),1);
            Us = -ones(length(stream),1);
            Vs = -ones(length(stream),1);
            Widths = -ones(length(stream),1);
            IDs = -ones(length(stream),1);
            
            for i = 1:length(stream)
                Times(i) = stream(i).time;
                Is(i) = stream(i).I;
                Qs(i) = stream(i).Q;
                Us(i) = stream(i).U;
                Vs(i) = stream(i).V;
                Widths(i) = stream(i).width;
                IDs(i) = stream(i).PulseID;
            end
            
            [Times,Inds] = sort(Times);
            Is = Is(Inds);
            Qs = Qs(Inds);
            Us = Us(Inds);
            Vs = Vs(Inds);
            Widths = Widths(Inds);
            IDs = IDs(Inds);
            
        end
        
        function inputpulses = checkInterference(obj,threshold)
            [Times,Is,~,~,~,Widths,IDs] = obj.streamData([obj.LeftInputStream,obj.RightInputStream,obj.TopInputStream,obj.BottomInputStream]);
            [Times,Inds] = sort(Times);
            IDs = IDs(Inds);
            Widths = Widths(Inds);
            Is = Is(Inds);
            dTimes = diff(Times);
            dWidths = (Widths(1:end-1) + Widths(2:end))/2;
            dLogPowers = abs(log10(Is(1:end-1)) - log10(Is(2:end)));
            BigPulse = Is(1:end-1) > threshold | Is(2:end) > threshold;
            Interferes = dTimes<dWidths & dLogPowers < 3 & BigPulse; % Interference, of pulses than can affect eachother, that we actually care about.
            inputpulses.first = IDs([Interferes;logical(0)]);
            inputpulses.second = IDs([logical(0);Interferes]);
            
            
            
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
            componentArray = PolarizingBeamSplitter.manageComponentArray([], 'getArray');
        end
        function componentArray =  clearComponent()
            componentArray = PolarizingBeamSplitter.manageComponentArray([], 'clear');
        end
        function componentArray = clearComponentArray()
            componentArray = PolarizingBeamSplitter.manageComponentArray('clear');
        end
        function comp = getComponent(id)
            comp = PolarizingBeamSplitter.manageComponentArray(id, 'getComponent');
        end
    end
    
end

