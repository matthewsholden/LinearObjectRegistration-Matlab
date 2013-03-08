% This function will calculate the closest point of intersection for an
% arbitrary number of lines. Of course, if the lines intersect exactly,
% this will produce the optimal solution

%Parameter L: A cell array of Lines

%Return point: A point that represents the closest point of intersection
function point = LineIntersection( L )

% The idea is to minimize the dot product of the normal vectors with the
% intersection point in the least squares sense
% ( basePoint - point ) . u = ( basePoint - point ) . v = 0

U = zeros( 2 * numel(L) , 3 );
B = zeros( 2 * numel(L) , 1 );

for i = 1:numel(L)
    
    % Find the u and v vectors orthogonal to the line (Gram-Schmidt)
    direction = L{i}.GetDirection();
    
    % Use the standard basis as a starting point
    if ( max( direction ) == direction(1) )
        e1 = [ 0; 1; 0 ];
        e2 = [ 0; 0; 1 ];
    elseif ( max( direction ) == direction(2) )
        e1 = [ 1; 0; 0 ];
        e2 = [ 0; 0; 1 ];
    elseif ( max( direction ) == direction(3) )
        e1 = [ 1; 0; 0 ];
        e2 = [ 0; 1; 0 ];
    end

    u = e1 - dot( e1, direction ) * direction;
    u = u / norm( u );
    
    v = e2 - dot( e2, direction ) * direction - dot( e2, u ) * u;
    v = v / norm( v );
    
    % Now add to the U and B matrices
    U( 2*i-1, : ) = u';
    U( 2*i, : ) = v';
    
    B( 2*i-1 ) = dot( L{i}.endPoint1, u );
    B( 2*i ) = dot( L{i}.endPoint1, v );    
    
end %for

% Solve for point in the least squares sense
point = ( U' * U ) \ U' * B;
