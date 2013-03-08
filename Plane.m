%Represent a plane

classdef Plane
    
    properties ( SetAccess = private )
        basePoint;
        endPoint1;
        endPoint2;
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
            distance = dot( A.GetNormal, point );
        end %function
        
        function point = ProjectPoint( A, point )
            vector = point - A.basePoint;
            direction1 = A.endPoint1 - A.basePoint;
            direction1 = direction1 / norm( direction1 );
            direction2 = A.endPoint2 - A.basePoint;
            direction2 = direction2 / norm( direction2 );
            
            point = dot( direction1, vector ) * direction1 + dot( direction2, vector ) * direction2;  
            point = point + A.basePoint;
        end %function
        
        function L = GetIntersection( A1, A2 )
            
            % The direction of the line is orthogonal to both normals
            n1 = A1.GetNormal();
            n2 = A2.GetNormal();
            direction = cross( A1.GetNormal(), A2.GetNormal() );
            
            % Solve for some point on the line
            d1 = dot( n1, A1.basePoint );
            d2 = dot( n2, A2.basePoint );
            D = [ d1; d2 ];
            M1 = [ n1(2), n1(3); n2(2) n2(3) ];
            M2 = [ n1(1), n1(3); n2(1) n2(3) ];
            M3 = [ n1(1), n1(2); n2(1) n2(2) ];
        
            DM1 = abs( det(M1) );
            DM2 = abs( det(M2) );
            DM3 = abs( det(M3) );

            point = zeros( 3, 1 );
            if ( DM1 >= DM2 && DM1 >= DM3 )
                sol = M1 \ D;
                point(2) = sol(1);
                point(3) = sol(2);
            elseif ( DM2 >= DM1 && DM2 >= DM3 )
                sol = M2 \ D;
                point(1) = sol(1);
                point(3) = sol(2);                
            elseif ( DM3 >= DM1 && DM3 >= DM2 )
                sol = M3 \ D;
                point(1) = sol(1);
                point(2) = sol(2);          
            end %if

            %Now, the line can be found as
            LT = Line( point, point + direction );
            
            % Project each point onto the line and find the farthest two
            % apart
            proj = cell(1,8);
            proj{1} = LT.ProjectPoint( A1.basePoint );
            proj{2} = LT.ProjectPoint( A1.endPoint1 );
            proj{3} = LT.ProjectPoint( A1.endPoint2 );
            proj{4} = LT.ProjectPoint( A1.GetOppositeBasePoint() );
            proj{5} = LT.ProjectPoint( A2.basePoint );
            proj{6} = LT.ProjectPoint( A2.endPoint1 );
            proj{7} = LT.ProjectPoint( A2.endPoint2 );
            proj{8} = LT.ProjectPoint( A2.GetOppositeBasePoint() );
            
            endPointMin = proj{1};
            endPointMax = proj{8};
            
            for i = 1:8
                if ( dot( proj{i}, LT.GetDirection() ) < dot( endPointMin, LT.GetDirection() ) )
                    endPointMin = proj{i};
                end %if
                if ( dot( proj{i}, LT.GetDirection() ) > dot( endPointMax, LT.GetDirection() ) )
                    endPointMax = proj{i};
                end %if
            end %for

            L = Line( endPointMin, endPointMax );
            
        end %function
        
    end %methods
    
    
    
end %classdef