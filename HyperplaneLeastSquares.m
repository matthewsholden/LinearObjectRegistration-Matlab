% Perform a linear least squares from a set of observations, and from it,
% calculate the associated hyperplane

%Parameter XYZ: Matrix of observations
%Parameter noise: The amplitude of noise in the collected points

%Return H: A hyperplane calculate from the linear least squares
function H = HyperplaneLeastSquares( XYZ, noise )

%Determine if it is a plane, line or point
THRESHOLD = max( 2, 2 * ( noise ^ 2 ) );

% Use PCA - it tells us how many principal components needed to represent
%eigenvalues = eig(corr(XYZ))
eigenvalues = eig(cov(XYZ));
%The degrees of freedom corresponds to the number of eigenvalues larger
%than some threshold
dof = length( find( eigenvalues > THRESHOLD ) );


% If we are at a plane
if ( dof >= 2 )
    
    % Choose the dependent variable to be the one with the least variance
    dimVector = 1:3;
    [ ~, minVar ] = min( diag( cov(XYZ) ) );
    depVector = minVar;
    indVector = dimVector( dimVector ~= minVar );    
    
    DEP = XYZ( :, depVector );
    IND = XYZ( :, indVector );
    
    C = LinearLeastSquares( DEP , IND );
    
    basePoint = zeros( 3, 1 );
    basePoint( depVector ) = C(1,1);
    
    endPoint1 = basePoint;
    endPoint1( indVector(1) ) = endPoint1( indVector(1) ) + 1;
    endPoint1( depVector ) = endPoint1( depVector ) + C(2,1);
    
    endPoint2 = basePoint;
    endPoint2( indVector(2) ) = endPoint2( indVector(2) ) + 1;
    endPoint2( depVector ) = endPoint2( depVector ) + C(3,1);
    
    H = Plane( basePoint, endPoint1, endPoint2 );
    
end %if

% If we are at a line
if ( dof == 1 )
    
    % Choose the independent variable to be the one with the most variance
    dimVector = 1:3;
    [ ~, maxVar ] = max( diag( cov(XYZ) ) );
    indVector = maxVar;
    depVector = dimVector( dimVector ~= maxVar );    
    
    IND = XYZ( :, indVector );
    DEP = XYZ( :, depVector );
    
    C = LinearLeastSquares( DEP , IND );
    
    endPoint1 = zeros( 3, 1 );
    endPoint1( depVector(1) ) = C(1,1);
    endPoint1( depVector(2) ) = C(1,2);
    
    endPoint2 = endPoint1;
    endPoint2( indVector ) = endPoint2( indVector ) + 1;
    endPoint2( depVector(1) ) = endPoint2( depVector(1) ) + C(2,1);
    endPoint2( depVector(2) ) = endPoint2( depVector(2) ) + C(2,2);
    
    H = Line( endPoint1, endPoint2 );
    
end %if

% If we are at a point
if ( dof == 0 )
    H = Point( mean( XYZ, 1 )' );
end %if