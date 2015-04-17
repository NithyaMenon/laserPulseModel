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
        BackReflectance;
        M_trans;
        M_ref;
        
        Cutoff_Power = 1e-8; % HardCoded
        
        
    end
    
    methods
        function obj = PolarizingBeamSplitter(Psi,Transmittance,Reflectance,Ghost,BackReflectance)
            id = PolarizingBeamSplitter.manageComponentArray(obj, 'add');
            obj.ID = id;
            
            global montecarlo;
            global ErrorSpecs;
            TransRefsd = ErrorSpecs.PolarizingBeamSplitter.TransRef;
            Ghostsd = ErrorSpecs.PolarizingBeamSplitter.Ghost;
            Psisd = ErrorSpecs.PolarizingBeamSplitter.Psi;
            BackRefsd = ErrorSpecs.PolarizingBeamSplitter.Back;
            
            obj.Psi = Psi*(1 + montecarlo*Psisd*randn(1,1));
            obj.Reflectance = Reflectance*(1 + montecarlo*TransRefsd*randn(1,1));
            obj.Transmittance = Transmittance*(1 + montecarlo*TransRefsd*randn(1,1));
            obj.Ghost = Ghost*(1 + montecarlo*Ghostsd*randn(1,1));
            obj.BackReflectance = BackReflectance*(1 + montecarlo*BackRefsd*randn(1,1));
            
            global SampledErrors
            se = struct('ID',obj.ID,'Psi',obj.Psi,...
                'Reflectance',obj.Reflectance,...
                'Transmittance',obj.Transmittance,...
                'Ghost',obj.Ghost',...
                'BackReflectance',obj.BackReflectance);
            SampledErrors.PolarizingBeamSplitter =...
                [SampledErrors.PolarizingBeamSplitter, se];
            
            
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
            
            streamSize = 5000; % For Preallocation
            obj.TopInputStream = StreamArray(streamSize);
            obj.LeftInputStream = StreamArray(streamSize);
            obj.RightInputStream = StreamArray(streamSize);
            obj.BottomInputStream = StreamArray(streamSize);
            obj.TopOutputStream = StreamArray(streamSize);
            obj.LeftOutputStream = StreamArray(streamSize);
            obj.RightOutputStream = StreamArray(streamSize);
            obj.BottomOutputStream = StreamArray(streamSize);
            
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
                            obj.TopOutputStream.add(pulse);
                            topOut.addPulse(pulse);
                        case 'Right'
                            obj.RightOutputStream.add(pulse);
                            rightOut.addPulse(pulse);
                        case 'Left'
                            obj.LeftOutputStream.add(pulse);
                            leftOut.addPulse(pulse);
                        case 'Bottom'
                            obj.BottomOutputStream.add(pulse);
                            bottomOut.addPulse(pulse);
                    end
                end
            end
            
            for p = leftPulses
                obj.LeftInputStream.add(p);
                [LT,LR,LG,LBR] = obj.action(p);
                addAPulse('Left',LBR);
                addAPulse('Right',LT);
                addAPulse('Bottom',LG);
                addAPulse('Top',LR);
                
            end
            
            for p = topPulses
                obj.TopInputStream.add(p);
                [TT,TR,TG,TBR] = obj.action(p);
                addAPulse('Top',TBR);
                addAPulse('Right',TG);
                addAPulse('Bottom',TT);
                addAPulse('Left',TR);
                
            end
            
            for p = bottomPulses
                obj.BottomInputStream.add(p);
                [BT,BR,BG,BBR] = obj.action(p);
                addAPulse('Bottom',BBR);
                addAPulse('Right',BR);
                addAPulse('Top',BT);
                addAPulse('Left',BG);
%                 
            end
            for p = rightPulses
                obj.RightInputStream.add(p);
                [RT,RR,RG,RBR] = obj.action(p);
                addAPulse('Right',RBR);
                addAPulse('Top',RG);
                addAPulse('Bottom',RR);
                addAPulse('Left',RT);
                
            end
            
            result = [topOut.ID*~topOut.Empty(), leftOut.ID*~leftOut.Empty(),...
                rightOut.ID*~rightOut.Empty(), bottomOut.ID*~bottomOut.Empty()];
        end
        
        
        function [transmitPulse,reflectPulse,ghostPulse,backreflectPulse] = action(obj,inputPulse)
            
            transmitPulse = inputPulse;
            reflectPulse = Pulse.clonePulse(inputPulse);
            ghostPulse = Pulse.clonePulse(inputPulse);
            backreflectPulse = Pulse.clonePulse(inputPulse);
            
            S = [inputPulse.I;inputPulse.Q;inputPulse.U;inputPulse.V];
            
            Sout = obj.Transmittance*(obj.M_trans)*S;
            
            transmitPulse.I = Sout(1);
            transmitPulse.Q = Sout(2);
            transmitPulse.U = Sout(3);
            transmitPulse.V = Sout(4);
            
            Sout = obj.BackReflectance*(obj.M_trans)*S;
            
            backreflectPulse.I = Sout(1);
            backreflectPulse.Q = Sout(2);
            backreflectPulse.U = Sout(3);
            backreflectPulse.V = Sout(4);
            
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
            state_creator = sprintf('PolarizingBeamSplitterBackReflect %i',...
                obj.ID);
            Pulse.saveStateHistory(backreflectPulse,state_creator);
        
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
            [Times,Is,~,~,~,Widths,IDs] = obj.streamData([obj.LeftInputStream,obj.RightInputStream,obj.TopInputStream,obj.BottomInputStream]);
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

