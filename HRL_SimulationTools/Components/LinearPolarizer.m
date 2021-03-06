classdef LinearPolarizer < Component
    %LINEARPOLARIZER Component object for calling by S-function
    %   LP = LinearPolarizer(Psi,Transmittance,ExtinctionRatio) returns a 
    %       LinearPolarizer object. 
    %       Usage requires global variables 'montecarlo', 'UseGivenErrors'
    %       (logicals), 'ErrorSpecs', 'SampledErrors' (structs) to be
    %       initialized.
    %
    %   result = LP.apply(pulseArrayIDs) uses the Mueller calculus and
    %       specified parameters (with specified jitter) to mutate the
    %       pulses in each PulseArray specified by 'pulseArrayIDs'.
    %       'pulseArrayIDs' is expected to be a vector of length 2, and
    %       called using IDs passed to the 2 input channels of the 
    %       component, by the S-function component_s.
    %
    %   result = LP.action(pulse) applies the specified Mueller calculus
    %       for LP to the Pulse 'pulse' and returns a logical indicating
    %       success.
    %
    %   [Times,Is,Qs,Us,Vs,Widths,IDs] = LP.streamData(stream) returns
    %       arrays containing the characterisitcs of every pulse that has
    %       entered LP.
    %
    %   numCollisions = LP.checkInterference(importantPulses) takes in an
    %       array of Pulse IDs of pulses considered important and checks
    %       the input StreamArrays of PBS to see if there is any overlap in
    %       timing between pulses that were ever once the important pulses.
    %
    %   [STATIC] LP = LinearPolarizer.getComponent(id) returns the
    %       LinearPolarizer Object with the ID 'id', throws an
    %       error if the no object has the ID.
    %
    %   See also: Pulse, PulseArray, component_s
    
    properties
        ID;
        
        LeftInputStream;
        RightInputStream;
        LeftOutputStream;
        RightOutputStream;
        
        % Component Specific Params
        Psi;
        Transmittance;
        ExtinctionRatio;
        M_pass;
        M_stop;
        
        
    end
    
    methods
        function obj = LinearPolarizer(Psi,Transmittance,ExtinctionRatio)
            id = LinearPolarizer.manageComponentArray(obj, 'add');
            obj.ID = id;
            
            % Hard-coded Jitter
            global montecarlo;
            global ErrorSpecs;
            global SampledErrors;
            global UseGivenErrors;
            
            if (UseGivenErrors == 1);
                problem = 1;
                for s = SampledErrors.LinearPolarizer
                    if(s.ID == obj.ID)
                        obj.Psi = s.Psi;
                        obj.Transmittance = s.Transmittance;
                        problem = 0;
                        break;
                    end
                end
                if(problem)
                    display('ERROR: Object not specified by SampledErrors');
                end
            else
            
                Psisd = ErrorSpecs.LinearPolarizer.Psi;
                Transsd = ErrorSpecs.LinearPolarizer.Transmission;

                obj.Psi = Psi + montecarlo*Psisd*randn(1,1);
                obj.Transmittance = Transmittance + montecarlo*Transsd*randn(1,1);


                se = struct('ID',obj.ID,'Psi',obj.Psi,...
                    'Transmittance',obj.Transmittance);
                SampledErrors.LinearPolarizer =...
                    [SampledErrors.LinearPolarizer, se];
            end
            
            obj.ExtinctionRatio = ExtinctionRatio;

            
            streamSize = 5000; % For Preallocation
            obj.LeftInputStream = StreamArray(streamSize);
            obj.RightInputStream = StreamArray(streamSize);
            obj.LeftOutputStream = StreamArray(streamSize);
            obj.RightOutputStream = StreamArray(streamSize);
            
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
                obj.LeftInputStream.add(p);
                obj.action(p);
                obj.RightOutputStream.add(p);
                
            end
            for p = rightPulses
                obj.RightInputStream.add(p);
                obj.action(p);
                obj.LeftOutputStream.add(p);
                
            end
            result = pulseArrayIDs;
        end
        function result = action(obj,inputPulse)
            
            % Apply Mueller matrix
            S = [inputPulse.I;inputPulse.Q;inputPulse.U;inputPulse.V];
            Sout = obj.Transmittance*(obj.M_pass + obj.M_stop/obj.ExtinctionRatio)*S;
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

