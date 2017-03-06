%Represent a plane

classdef Plane
    
    properties ( SetAccess = private )
        basePoint;
        endPoint1;
        endPoint2;
        signature;
    end %properties
    
    methods
        
        function A = Plane( basePoint_, endPoint1_, endPoint2_ )
            A.basePoint = basePoint_;
            A.endPoint1 = endPoint1_;
            A.endPoint2 = endPoint2_;
        end %function
        
        function vector = GetNormal( A )
            vector = cross( A.basePoint - A.endPoint1, A.basePoint - A.endPoint2 );
            vector = vector / norm( vector );
        end %function
        
        function point = GetOppositeBasePoint( A )
            point = A.basePoint + ( A.endPoint1 - A.basePoint ) + ( A.endPoint2 - A.basePoint );
        end %function
        
        function distance = DistanceToPoint( A, point )
            distance = abs( dot( A.GetNormal(), A.basePoint - point ) );
        end %function
        
        function point = ProjectPoint( A, point )
            vector = point - A.basePoint;            
            point = A.basePoint + vector - dot( vector, A.GetNormal() ) * A.GetNormal();  
        end %function
        
        function A = Signature( A, R ) % R is cell array of references
            A.signature = zeros( numel(R), 1 );
            for i = 1:numel(R)
                A.signature(i) = A.DistanceToPoint( R{i}.point );
            end %for
        end %function
        
        function A = Translate( A, vector )
            A.basePoint = A.basePoint + vector;
            A.endPoint1 = A.endPoint1 + vector;
            A.endPoint2 = A.endPoint2 + vector;
        end %function

    end %methods
    
    
    
end %classdef