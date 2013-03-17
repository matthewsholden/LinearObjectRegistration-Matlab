%Represent a reference

classdef Reference
    
    properties ( SetAccess = private )
        name;
        point;
    end %properties
    
    methods
        
        function L = Reference( name_, point_ )
            L.name = name_;
            L.point = point_;
        end %function
        
        function distance = DistanceToPoint( R, point )
            distance = norm( R.point - point );
        end %function
        
        function R = Translate( R, vector )
            R.point = R.point + vector;
        end %function
        
    end %methods
    
end %classdef