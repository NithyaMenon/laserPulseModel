classdef PockelsCell < Component
    %UNTITLED5 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ID;
        
        LeftInputStream;
        RightInputStream;
        LeftOutputStream;
        RightOutputStream;
        
        % Pockels Cell Params
        PCTimings;
        ControlPowers;
        onTimes = [];
        offTimes = [];
        
        sCurveFall;
        PCcurve;
        PCTransmittence;
        RFTime;
        Error;
        Psi;
        
    end
    
    methods
        function obj = PockelsCell(PCTimings,ControlPowers,Psi)
            id = PockelsCell.manageComponentArray(obj, 'add');
            obj.ID = id;
            
            % Hard-coded jitter
            global montecarlo;
            global ErrorSpecs;
            global UseGivenErrors;
            global SampledErrors;
            
            if (UseGivenErrors == 1);
                problem = 1;
                for s = SampledErrors.PockelsCell
                    if(s.ID == obj.ID)
                        obj.Psi = s.Psi;
                        obj.PCTransmittence = s.Transmittance;
                        sampSCurRand = s.SCurve;
                        problem = 0;
                        break;
                    end
                end
                if(problem)
                    display('ERROR: Object not specified by SampledErrors');
                end
            else
                
                Psisd = ErrorSpecs.PockelsCell.Psi;
                Transsd = ErrorSpecs.PockelsCell.Transmission;
                scursd = ErrorSpecs.PockelsCell.SCurve;

                obj.Psi = Psi*(1 + montecarlo*Psisd*randn(1,1));
                sampSCurRand = montecarlo*scursd*randn(1,1)+...
                    2.5*pi/180*~montecarlo;
                
                obj.RFTime = 8e-9; % (Rise-Fall Time) Hard-coded
                obj.PCTransmittence = 0.85*(1 + montecarlo*Transsd*randn(1,1)); % Hard-coded
                
                se = struct('ID',obj.ID,'Psi',obj.Psi,...
                'Transmittance',obj.PCTransmittence,...
                'SCurve',sampSCurRand);
                SampledErrors.PockelsCell =...
                [SampledErrors.PockelsCell, se];
                
            end
                
            streamSize = 5000; % For Preallocation
            obj.LeftInputStream = StreamArray(streamSize);
            obj.RightInputStream = StreamArray(streamSize);
            obj.LeftOutputStream = StreamArray(streamSize);
            obj.RightOutputStream = StreamArray(streamSize);
            
            if(mod(length(PCTimings), 2) ~= 0)
                display('Error in PC instantiation: Unequal on, off times');
            end
            if(length(PCTimings)/2 ~= length(ControlPowers))
                display('Error in PC instantiation: Not enough control powers');
            end
            
            
            
            
            %obj.sCurveFall = @(t,tStart) ((1.1241664308*10^8)*(t-(tStart+obj.RFTime)));
            obj.sCurveFall = @(t) (0.0112+(0.0876+1-((-0.135)+ 1.2348./(1+2*exp(-0.012*(t*1e11))).^2))/1.0876)/1.0092;
            obj.PCcurve = @(t,tStart,tEnd) (1+ sampSCurRand)*(obj.sCurveFall(-(t-tStart)).*(t<tStart) + ...
                1.*(tStart<=t && t<tEnd) + ...
                obj.sCurveFall(t-tEnd).*(t>=tEnd));
            
            %obj.PCcurve = @(t, tStart, tEnd) (1+sampSCurRand)*(obj.sCurveFall(t,tStart).*(t<tStart)+...
            %    1.*(tStart<=t && t<tEnd)+ obj.sCurveFall(-t,-tEnd).*(t>=tEnd));
            
            obj.onTimes = PCTimings(1:2:end);
            obj.offTimes = PCTimings(2:2:end);
            obj.ControlPowers = ControlPowers;
            
            
            
            
            
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
            psi = obj.Psi;
            t = inputPulse.time;
            calculatedValues = zeros(1,length(obj.onTimes));
            for i = 1:length(obj.onTimes)
                calculatedValues(i) = (obj.ControlPowers(i)*pi)*...
                    obj.PCcurve(t,obj.onTimes(i),obj.offTimes(i));
                
            end
            
            Tau = max(calculatedValues);
            
            % Compute Mueller matrix
            G = (1/2)*(1+cos(Tau));
            H = (1/2)*(1-cos(Tau));

            M = [1 0 0 0;...
                0 (G+H*cos(4*psi)) H*sin(4*psi) -sin(Tau)*sin(2*psi);...
                0 H*sin(4*psi) (G-H*cos(4*psi)) sin(Tau)*cos(2*psi);...
                0 sin(Tau)*sin(2*psi) -sin(Tau)*cos(2*psi) cos(Tau)];
            % Source for Mueller mx:
            % Polarization of Light: Basics to Instruments
            % N. Manset / CFHT

            % Apply Mueller mx
            S = [inputPulse.I; inputPulse.Q; inputPulse.U; inputPulse.V];
            Sout = obj.PCTransmittence*M*S;
            resultPulse = inputPulse;
            resultPulse.I = Sout(1);
            resultPulse.Q = Sout(2);
            resultPulse.U = Sout(3);
            resultPulse.V = Sout(4);
            
            % Concatenate resultPulseID to result array
            
            state_creator = sprintf('Pockels Cell %i: Tau = %0.3f pi',...
                obj.ID,Tau/pi);
            Pulse.saveStateHistory(resultPulse,state_creator);
            result = 1;
        end
        
        function curveData = curve(obj, timings)
            
            curveData = -ones(size(timings));
            for j = 1:length(curveData)
                t = timings(j);
                calculatedValues = zeros(1,length(obj.onTimes));
                for i = 1:length(obj.onTimes)
                    calculatedValues(i) = (obj.ControlPowers(i)*pi)*...
                        obj.PCcurve(t,obj.onTimes(i),obj.offTimes(i));

                end
                
                curveData(j) = max(calculatedValues);
            end  
        
        end
        function hand = plotIO(obj,maxTime)
            tt = -10e-9:0.1e-9:maxTime;
            
            curveData = obj.curve(tt);
            
            [inputTimes,inputI,inputQ,inputU,inputV,inputWidths,inputIDs] = ...
                obj.streamData([obj.LeftInputStream,obj.RightInputStream]);
%             [outputTimes,outputI,outputQ,outputU,outputV,outputWidths,outputIDs] = ...
%                 obj.streamData(obj.outputStream);
            
            
            inputIV = inputI.*(inputQ>=0);
            inputIH = inputI.*(inputQ<0);
            
            zeropad = zeros(size(inputTimes));
            timevec = [ inputTimes-inputWidths/2-eps; inputTimes-inputWidths/2; inputTimes+inputWidths/2;inputTimes+inputWidths/2+eps];
            IVvec = [ zeropad; inputIV; inputIV; zeropad];
            IHvec = [ zeropad; inputIH; inputIH; zeropad];
            [timevec,Inds] = sort(timevec);
            IVvec = IVvec(Inds);
            IHvec = IHvec(Inds);
            
            
            
            
            hand = figure();
            plot(timevec*1e9,IVvec,'LineWidth',2);
            hold on
            [AX,H1,H2] = plotyy(timevec*1e9,IHvec,tt*1e9,curveData/pi);
            set(H1,'LineWidth',2);
            set(H2,'LineWidth',2,'Color',[0.9290    0.6940    0.1250]);
            set(AX(2),'XLim',[-1,maxTime*1e9],'YLim',[0,1]);
            set(AX(1),'XLim',[-1,maxTime*1e9],'YLim',[0,2*max(inputI)]);
            h = legend('Vertically Polarized Input', 'Horizontally Polarized Input', 'Retardation by PC');
            set(h,'FontSize',14);
            
            titl = sprintf('Input Plot for Pockels Cell %i', obj.ID);
            title(titl,'FontSize',16);
            xlabel('Time [ns]','FontSize',14);
            AX(2).YLabel.String = 'Fraction of 90 Degree Rotation';
            AX(2).YLabel.FontSize = 14;
            ylabel('Pulse Intensity','FontSize',14);
            grid on
            
            
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
            componentArray = PockelsCell.manageComponentArray([], 'getArray');
        end
        function componentArray =  clearComponent()
            componentArray = PockelsCell.manageComponentArray([], 'clear');
        end
        function componentArray = clearComponentArray()
            componentArray = PockelsCell.manageComponentArray('clear');
        end
        function comp = getComponent(id)
            comp = PockelsCell.manageComponentArray(id, 'getComponent');
        end
    end
    
end

