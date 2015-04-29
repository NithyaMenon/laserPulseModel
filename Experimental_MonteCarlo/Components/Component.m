classdef Component < handle
    %COMPONENT (Abstract)
    %
    %   Relevant Methods:
    %   apply(pulseArrayIDs)
    %   checkInterference()
    %   [STATIC] getComponent(ID)

    
    properties(Abstract)
        
        
        ID;
        
        LeftInputStream;
        RightInputStream;
        LeftOutputStream;
        RightOutputStream;
        
    end
    
    methods(Abstract)
        result =  apply(obj,pulseArrayID);
        inputpulses = checkInterference(obj);
        
    end
    methods( Static, Abstract)
        result = manageComponentArray( cObj, operation);
        
        componentArray =  getComponentArray();
        
        componentArray =  clearComponent();
        
        componentArray = clearComponentArray();
        
        comp = getComponent(id);
        
        
        
    end
    
end

