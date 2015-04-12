classdef StreamArray < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ary;
        indx;
        size;
    end
    
    methods
        function obj = StreamArray(size)
            obj.size = size;
            
            obj.ary = repmat(struct('time',-1,'I',-1,'Q',-1,...
                'U',-1','V',-1,'width',-1,'ID',-1),size,1);
            obj.indx = 0;
        end
        function add(obj,pulse)
            obj.indx = obj.indx+1;
            obj.ary(obj.indx).time = pulse.time;
            obj.ary(obj.indx).I = pulse.I;
            obj.ary(obj.indx).Q = pulse.Q;
            obj.ary(obj.indx).U = pulse.U;
            obj.ary(obj.indx).V = pulse.V;
            obj.ary(obj.indx).width = pulse.width;
            obj.ary(obj.indx).ID = pulse.ID;
            
            % Expand if full
            if(obj.indx>=obj.size)
                ary_tmp = repmat(struct('time',-1,'I',-1,'Q',-1,...
                'U',-1','V',-1,'width',-1,'ID',-1),obj.size,1);
                obj.ary = [obj.ary,ary_tmp];
                obj.size = obj.size*2;
            end
        end
        function [Times,Is,Qs,Us,Vs,Widths,IDs] = thisStreamData(obj)
            Times = [obj.ary(1:obj.indx).time];
            Is = [obj.ary(1:obj.indx).I];
            Qs = [obj.ary(1:obj.indx).Q];
            Us = [obj.ary(1:obj.indx).U];
            Vs = [obj.ary(1:obj.indx).V];
            Widths = [obj.ary(1:obj.indx).width];
            IDs = [obj.ary(1:obj.indx).ID];
        end
            
    end
    
    methods(Static)
        function [Times,Is,Qs,Us,Vs,Widths,IDs] = StreamData(objArr)
            Times = [];
            Is = [];
            Qs = [];
            Us = [];
            Vs = [];
            Widths = [];
            IDs = [];
            for obj = objArr % Haven't preallocated because len(objArr)<=4
                [T,I,Q,U,V,W,ID] = obj.thisStreamData();
                Times = [Times,T];
                Is = [Is,I];
                Qs = [Qs,Q];
                Us = [Us,U];
                Vs = [Vs,V];
                Widths = [Widths,W];
                IDs = [IDs,ID];
            end
            Times = transpose(Times);
            Is = transpose(Is);
            Qs = transpose(Qs);
            Us = transpose(Us);
            Vs = transpose(Vs);
            Widths = transpose(Widths);
            IDs = transpose(IDs);
        end
    end
    
end

