% Perform a linear least squares from a set of observations, and from it,
% calculate the associated hyperplane, using pca

%Parameter XYZ: Matrix of observations
%Parameter DOF: Number of degrees of freedom associated with each object

%Return H: A hyperplane calculate from the linear least squares
function H = LinearObjectLeastSquares( XYZ, DOF )

% First, calculate the centroid of the point cloud
basePoint = mean( XYZ, 1 )';

% Next, calculate the principal component vectors
[ evector, ~ ] = eig( cov( XYZ ) );

% Find the eigenvectors
evector = evector( :, (end-DOF+1):end );


% If we are at a plane
if ( DOF >= 2 )    
    H = Plane( basePoint, basePoint + evector(:,1), basePoint + evector(:,2) );   
end %if

% If we are at a line
if ( DOF == 1 )
    H = Line( basePoint, basePoint + evector(:,1) );
end %if

% If we are at a point
if ( DOF == 0 )
    H = Point( basePoint );
end %if