%Represent a point

classdef Point
    
    properties ( SetAccess = private )
        point;
        signature;
    end %properties
    
    methods
        
        function P = Point( point_ )
            P.point = point_;
        end %function
        
        function distance = DistanceToPoint( P, point )
            distance = norm( P.point - point );
        end %function
        
        function P = Signature( P, R ) % R is cell array of references
            P.signature = zeros( numel(R), 1 );
            for i = 1:numel(R)
                P.signature(i) = P.DistanceToPoint( R{i}.point );
            end %for
        end %function
        
        function P = Translate( P, vector )
            P.point = P.point + vector;
        end %function
        
    end %methods
    
    
    
end %classdef