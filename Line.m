%Represent a line

classdef Line
    
    properties ( SetAccess = private )
        endPoint1;
        endPoint2;
        param1;
        param2;
        signature;
    end %properties
    
    methods
        
        function L = Line( endPoint1_, endPoint2_ )
            L.endPoint1 = endPoint1_;
            L.endPoint2 = endPoint2_;
        end %function
        
        function vector = GetDirection( L )
            vector = ( L.endPoint2 - L.endPoint1 );
            vector = vector / norm( vector );
        end %function
        
        function distance = DistanceToPoint( L, point )
            vector = point - L.endPoint1;
            %Direction vector will always be normalized
            orthVector = vector - dot( L.GetDirection(), vector ) * L.GetDirection();
            distance = norm( orthVector );
        end %function
        
        function point = ProjectPoint( L, point )
            vector = point - L.endPoint1;
            point = dot( L.GetDirection(), vector ) * L.GetDirection() + L.endPoint1;            
        end %function
        
        function L = Parameterize( L, point )
            L.param1 = dot( L.endPoint1 - L.ProjectPoint( point ), L.GetDirection() );
            L.param2 = dot( L.endPoint2 - L.ProjectPoint( point ), L.GetDirection() );
        end %function
        
        function L = Deparameterize( L, point, p1, p2 )
            direction = L.GetDirection(); % Must do this first - direction changes otherwise
            L.endPoint1 = L.ProjectPoint( point ) + p1 * direction;
            L.endPoint2 = L.ProjectPoint( point ) + p2 * direction;
        end %function
        
        function L = Signature( L, R ) % R is cell array of references
            L.signature = zeros( numel(R), 1 );
            for i = 1:numel(R)
                L.signature(i) = L.DistanceToPoint( R{i}.point );
            end %for
        end %function
        
    end %methods
    
    
    
end %classdef