% This function will take a geometry specification and convert it into a
% set of points for point-point registration

%Paramter fileName: The name of the file with the geometry specification

%Return points: A cell array of (ordered) points
function [ R P L A ] = GeomteryToPoints( fileName )

% Read from file and recover all the hyperplanes
[ R P L A ] = GeometryRead( fileName );

% First, convert the planes to lines
for i = 1:numel(A)
    
    for j = 1:(i-1)
        
        L = cat( 1, L, A{i}.GetIntersection( A{j} ) );
        
    end %for
    
end %for

% Next, convert the lines to points
if ( numel(L) > 1 )
    closestPoint = LineIntersection( L );
elseif ( numel(P) > 0 )
    closestPoint = PointCentroid( P );
else
    % If neither of these conditions are satisfied, then there is not enough
    % information for the registration
    warning('Ill-defined registration geometry');
end %if

% Find the signatures and parameterizations for each of the lines
for i = 1:numel(L)
    L{i} = L{i}.Signature( R );
    L{i} = L{i}.Parameterize( closestPoint );
end %for



%Finally, find the list of points
for i = 1:numel(L)
    
    P = cat( 1, P, Point( L{i}.endPoint1 ) );
    P = cat( 1, P, Point( L{i}.endPoint2 ) );
    
end %for

% Now, we want point objects with signatures
for i = 1:numel(P)
    P{i} = P{i}.Signature( R );
end %for
