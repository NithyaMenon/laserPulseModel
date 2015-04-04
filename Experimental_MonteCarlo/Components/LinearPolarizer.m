classdef LinearPolarizer < Component
    %UNTITLED5 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ID;
        
        LeftInputStream;
        RightInputStream;
        LeftOutputStream;
        RightOutputStream;
        
        % Component Specific Params
        Psi;
        Transmittence;
        ExtinctionRatio;
        M_pass;
        M_stop;
        
        
    end
    
    methods
        function obj = LinearPolarizer(Psi,Transmittence,ExtinctionRatio)
            id = LinearPolarizer.manageComponentArray(obj, 'add');
            obj.ID = id;
            
            % Hard-coded Jitter
            global montecarlo;
            Psisd = 0.02*pi;
            Transsd = 0.01*pi;
            
            obj.Psi = Psi + montecarlo*Psisd*randn(1,1);
            obj.Transmittence = Transmittence + montecarlo*Transsd*randn(1,1);
            obj.ExtinctionRatio = ExtinctionRatio;
            obj.LeftInputStream = [];
            obj.RightInputStream = [];
            obj.LeftOutputStream = [];
            obj.RightOutputStream = [];
            
            %% Compute and save Mueller matrix
            % Algorithm Soruce
            % http://en.wikipedia.org/wiki/Mueller_calculus#Mueller_vs._Jones_calculi
            % http://en.wikipedia.org/wiki/Jones_calculus#Jones_matrices
            % Compute Jones Matrix
            
            Psi_2 = Psi + pi/2; % psi_2 is the block axis
            J_pass = [cos(Psi)^2, cos(Psi)*sin(Psi);...
                sin(Psi)*cos(Psi), sin(Psi)^2];
            J_stop = [cos(Psi_2)^2, cos(Psi_2)*sin(Psi_2);...
                sin(Psi_2)*cos(Psi_2), sin(Psi_2)^2];
            % Compute Mueller Matrix
            A = [ 1 0 0 1;...
                1 0 0 -1;...
                0 1 1 0;...
                0 1i -1i 0];
            obj.M_pass = A*kron(J_pass,conj(J_pass))*inv(A);
            obj.M_stop = A*kron(J_stop,conj(J_stop))*inv(A);
            
        end
        function result = apply(obj,pulseArrayIDs)
            leftPulses = PulseArray.getPulses(pulseArrayIDs(1));
            rightPulses = PulseArray.getPulses(pulseArrayIDs(2));
            for p = leftPulses
                obj.LeftInputStream = [obj.LeftInputStream,samplePulseObject(p)];
                obj.action(p);
                obj.LeftOutputStream = [obj.LeftOutputStream,samplePulseObject(p)];
                
            end
            for p = rightPulses
                obj.RightInputStream = [obj.RightInputStream,samplePulseObject(p)];
                obj.action(p);
                obj.RightOutputStream = [obj.RightOutputStream,samplePulseObject(p)];
                
            end
            result = pulseArrayIDs;
        end
        function result = action(obj,inputPulse)
            
            % Apply Mueller matrix
            S = [inputPulse.I;inputPulse.Q;inputPulse.U;inputPulse.V];
            Sout = obj.Transmittence*(obj.M_pass + obj.M_stop/obj.ExtinctionRatio)*S;
            inputPulse.I = Sout(1);
            inputPulse.Q = Sout(2);
            inputPulse.U = Sout(3);
            inputPulse.V = Sout(4);
            
            resultPulse = inputPulse;
            
            
            
            %% State Saving
            
            state_creator = sprintf('LinearPolarizer %i',...
                obj.ID);
            Pulse.saveStateHistory(resultPulse,state_creator);
            result = 1;
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
            [Times,Is,~,~,~,Widths,IDs] = obj.streamData([obj.LeftInputStream,obj.RightInputStream]);
            [Times,Inds] = sort(Times);
            IDs = IDs(Inds);
            Widths = Widths(Inds);
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
            componentArray = LinearPolarizer.manageComponentArray([], 'getArray');
        end
        function componentArray =  clearComponent()
            componentArray = LinearPolarizer.manageComponentArray([], 'clear');
        end
        function componentArray = clearComponentArray()
            componentArray = LinearPolarizer.manageComponentArray('clear');
        end
        function comp = getComponent(id)
            comp = LinearPolarizer.manageComponentArray(id, 'getComponent');
        end
    end
    
end

