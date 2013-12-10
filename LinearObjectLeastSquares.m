% Perform a linear least squares from a set of observations, and from it,
% calculate the associated hyperplane, using pca

%Parameter XYZ: Matrix of observations
%Parameter noise: The amplitude of noise in the collected points

%Return H: A hyperplane calculate from the linear least squares
function H = LinearObjectLeastSquares( XYZ, noise )

%Determine if it is a plane, line or point
THRESHOLD = max( 0.5, 2 * ( noise ^ 2 ) );

% First, calculate the centroid of the point cloud
basePoint = mean( XYZ, 1 )';

% Next, calculate the principal component vectors
[ evector, evalues ] = eig( cov( XYZ ) );

% Find the eigenvectors with eigenvalues greater than the THRESHOLD
evalues = diag( evalues );
evector = evector( :, evalues > THRESHOLD );

% The number of important eigenvectors
dof = size( evector, 2 );


% If we are at a plane
if ( dof > 2 )
    evector = [ evector', evalues ];
    evector = sortrows( evector, - size( evector, 1 ) );
    evector = evector( 1:2, 1:(end-1) )';
    dof = 2;
end

if ( dof == 2 )
    H = Plane( basePoint, basePoint + evector(:,1), basePoint + evector(:,2) );
end %if

% If we are at a line
if ( dof == 1 )
    H = Line( basePoint, basePoint + evector(:,1) );
end %if

% If we are at a point
if ( dof == 0 )
    H = Point( basePoint );
end %if