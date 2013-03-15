% This function will calculate the closest point of intersection for an
% arbitrary number of lines and points.

%Parameter P: A cell array of points
%Parameter L: A cell array of Lines
%Parameter A: A cell array of planes

%Return point: A point that represents the centroid of all the objects
function point = LinearObjectCentroid( P, L, A )


% For points, we want
% point = point

U = zeros( 0 , 3 );
B = zeros( 0 , 1 );

for i = 1:numel(P)
    U = cat( 1, U, eye(3) );
    B = cat( 1, B, P{i}.point );
end %for


% The idea is to minimize the dot product of the normal vectors with the
% intersection point in the least squares sense
% ( basePoint - point ) . u = ( basePoint - point ) . v = 0

for i = 1:numel(L)
    
    % Find the u and v vectors orthogonal to the line (Gram-Schmidt)
    direction = L{i}.GetDirection();
    
    % Use the standard basis as a starting point
    if ( max( abs( direction ) ) == abs( direction(1) ) )
        e1 = [ 0; 1; 0 ];
        e2 = [ 0; 0; 1 ];
    elseif ( max( abs( direction ) ) == abs( direction(2) ) )
        e1 = [ 1; 0; 0 ];
        e2 = [ 0; 0; 1 ];
    elseif ( max( abs( direction ) ) == abs( direction(3) ) )
        e1 = [ 1; 0; 0 ];
        e2 = [ 0; 1; 0 ];
    end

    u = e1 - dot( e1, direction ) * direction;
    u = u / norm( u );
    
    v = e2 - dot( e2, direction ) * direction - dot( e2, u ) * u;
    v = v / norm( v );
    
    % Now add to the U and B matrices
    U = cat( 1, U, u' );
    U = cat( 1, U, v' );
    
    B = cat( 1, B, dot( L{i}.endPoint1, u ) );
    B = cat( 1, B, dot( L{i}.endPoint1, v ) ); 
    
end %for


% The idea is to minimize the dot product of the normal vector with the
% centroid point in the least sqaures sense
% ( basePoint - point ) . n = 0 

for i = numel(A)
    
    U = cat( 1, U, A{i}.GetNormal()' );
    
    B = cat( 1, B, dot( A{i}.basePoint, A{i}.GetNormal() ) );
    
end %for

% Solve for point in the least squares sense
point = ( U' * U ) \ U' * B;
