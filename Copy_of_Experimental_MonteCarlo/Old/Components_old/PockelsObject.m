classdef PockelsObject < handle
    %POCKELSOBJECT 
    %   The PockelsObject can be called with the following example piece of
    %   code: PC1 = PockelsObject([timings,controlpowers]) . The timings
    %   argument is expected to be [onTime1,offTime1,onTime2,offTime2,...]
    %   and the controlPowers argument is expected to be
    %   [controlPower1,...controlPowerN], where N is the number of onTimes
    %   in timings.
    %
    %   Relevant Methods:
    %     Pulse.curve(timesVec) returns a vector curvesVec that gives you
    %     the corresponding PC Tau value at time values specified by
    %     timesVec.
    
    properties 
        
        sCurveFall;
        PCcurve;
        PCTransmittence;
        RFTime;
        Error;
        
        ID;
        onTimes = [];
        offTimes = [];
        controlPowers = [];
        
        inputStream = [];
        outputStream = [];
        
    end
    
    methods
        function obj = PockelsObject( times, controlPowers )
            % Expected format for times:
            %  [ontime1, offtime1, ontime2, offtime2,...]
            %  Assumption: onTime referes to risetime (8 ns) AFTER
            %    PC has been turned on. Ex. onTime = 13 ns assumes it
            %    is actually turned on at 13 - 8 = 5 ns.
            %   Off-time, on the other hand, is when it is turned off.
            %   To summarize, onTime, offTime specify the period when 
            %   the PC is NOT transitioning.
            
            if(mod(length(times), 2) ~= 0)
                display('Error in PC instantiation: Unequal on, off times');
            end
            if(length(times)/2 ~= length(controlPowers))
                display('Error in PC instantiation: Not enough control powers');
            end
            
            obj.RFTime = 8e-9; % (Rise-Fall Time) Hard-coded
            obj.PCTransmittence = 0.85; % Hard-coded
            obj.Error = 2.5*pi/180; 
            
            obj.sCurveFall = @(t) (0.0112+(0.0876+1-((-0.135)+ 1.2348./(1+2*exp(-0.012*(t*1e11))).^2))/1.0876)/1.0092;
            obj.PCcurve = @(t,tStart,tEnd) obj.sCurveFall(-(t-tStart)).*(t<tStart) + ...
                1.*(tStart<=t && t<tEnd) + ...
                obj.sCurveFall(t-tEnd).*(t>=tEnd);
            
            obj.onTimes = times(1:2:end);
            obj.offTimes = times(2:2:end);
            obj.controlPowers = controlPowers;
            
            
            
            id = PockelsObject.managePockelsArray(obj, 'add');
            obj.ID = id;
            
        end
        function resultPulse = applyPockels(obj,inputPulse, psi)
            % Input: the input pulse, not just reference ID
            
            obj.inputStream = [obj.inputStream,samplePulseObject(inputPulse)];
            
            t = inputPulse.time;
            calculatedValues = zeros(1,length(obj.onTimes));
            for i = 1:length(obj.onTimes)
                calculatedValues(i) = (obj.controlPowers(i)*pi-obj.Error)*...
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
            
            
            obj.outputStream = [obj.outputStream,samplePulseObject(resultPulse)];
        end
        function curveData = curve(obj, timings)
            
            curveData = -ones(size(timings));
            for j = 1:length(curveData)
                t = timings(j);
                calculatedValues = zeros(1,length(obj.onTimes));
                for i = 1:length(obj.onTimes)
                    calculatedValues(i) = (obj.controlPowers(i)*pi-obj.Error)*...
                        obj.PCcurve(t,obj.onTimes(i),obj.offTimes(i));

                end
                
                curveData(j) = max(calculatedValues);
            end  
        
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
        function hand = plotIO(obj,maxTime)
            tt = -10e-9:0.1e-9:maxTime;
            curveData = obj.curve(tt);
            
            [inputTimes,inputI,inputQ,inputU,inputV,inputWidths,inputIDs] = ...
                obj.streamData(obj.inputStream);
%             [outputTimes,outputI,outputQ,outputU,outputV,outputWidths,outputIDs] = ...
%                 obj.streamData(obj.outputStream);
            
            
            inputIV = inputI.*(inputQ>=0);
            inputIH = inputI.*(inputQ<0);
            
            zeropad = zeros(size(inputTimes));
            timevec = [ inputTimes-inputWidths/2-eps; inputTimes-inputWidths/2; inputTimes+inputWidths/2;inputTimes+inputWidths/2+eps];
            IVvec = [ zeropad; inputIV; inputIV; zeropad];
            IHvec = [ zeropad; inputIH; inputIH; zeropad];
%             plotdata = transpose([timevec;Ivec]);
%             [Y,Inds] = sort(plotdata(:,1));
%             plotdata = plotdata(Inds,:);
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
        
    end
    methods( Static = true, Access = 'private')
        function result = managePockelsArray( pObj, operation)
            persistent pockelsarray
            persistent id;
            switch operation
                case 'add'
                    if(isempty(pockelsarray))
                        pockelsarray = [pObj];
                        id = 1;
                        result = id;
                    else
                        id = id+1;
                        pockelsarray(id) = pObj;
                        result = id;
                    end
                case 'getArray'
                    result = pockelsarray; % RETURNS A COPY. USE SET TO ALTER.
                case 'getPockelsObject'
                    result = pockelsarray(pObj); % pulse is id here
                case 'clear'
                    pockelsarray = [];
                    id = 0;
                    result = 1;
            end
        end
        
        
    end
    methods(Static)
        function pockelsArray =  getPockelsArray()
            pockelsArray = PockelsObject.managePockelsArray([], 'getArray');
        end
        function pockelsArray =  clearPockels()
            pockelsArray = PockelsObject.managePockelsArray([], 'clear');
        end
        function pockelsArray = clearPockelsArray()
            pockelsArray = PockelsObject.managePockelsArray('clear');
        end
        function pockelsObj = getPockelsObject(id)
            pockelsObj = PockelsObject.managePockelsArray(id, 'getPockelsObject');
        end
        
    end
    
end

