classdef PockelsObject < handle
    %UNTITLED11 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties 
        
        sCurveFall;
        PCcurve;
        PCTransmittence;
        RFTime;
        Error;
        
        ID;
        onTimes = [];
        offTimes = [];
        
    end
    
    methods
        function obj = PockelsObject( times )
            % Expected format for times:
            %  [ontime1, offtime1, ontime2, offtime2,...]
            %  Assumption: onTime referes to risetime (8 ns) AFTER
            %    PC has been turned on. Ex. onTime = 13 ns assumes it
            %    is actually turned on at 13 - 8 = 5 ns.
            %   Off-time, on the other hand, is when it is turned off.
            %   To summarize, onTime, offTime specify the period when 
            %   the PC is NOT transitioning.
            
            obj.RFTime = 8e-9; % (Rise-Fall Time) Hard-coded
            obj.PCTransmittence = 0.85; % Hard-coded
            obj.Error = 2.5*pi/180; 
            
            obj.sCurveFall = @(t) (0.0112+(0.0876+1-((-0.135)+ 1.2348./(1+2*exp(-0.012*(t*1e11))).^2))/1.0876)/1.0092;
            obj.PCcurve = @(t,tStart,tEnd) obj.sCurveFall(-(t-tStart)).*(t<tStart) + ...
                1.*(tStart<=t && t<tEnd) + ...
                obj.sCurveFall(t-tEnd).*(t>=tEnd);
            
            obj.onTimes = times(1:2:end);
            obj.offTimes = times(2:2:end);
            
            
            
            
            id = PockelsObject.managePockelsArray(obj, 'add');
            obj.ID = id;
            
        end
        function resultPulse = applyPockels(obj,inputPulse, psi)
            % Input: the input pulse, not just reference ID
            
            t = inputPulse.time;
            calculatedValues = zeros(1,length(obj.onTimes));
            for i = 1:length(obj.onTimes)
                calculatedValues(i) = (pi-obj.Error)*...
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

