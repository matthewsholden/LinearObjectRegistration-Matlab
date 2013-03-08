% Perform a linear least squares on a set of points

%Parameter Y: Matrix of dependent observations
%Parameter X: Matrix of independent observations

%Return coeff: Matrix of linear least squares coefficients
function coeff = LinearLeastSquares( Y, X )

%Note: Column is record, row is variable
ERROR_THRESHOLD = 3; % 5 seems to be optimal from our tests
err = ones( size(X,1), 1 ) * Inf;
avgerr = 0;


% First, pad the X matrix
X = cat( 2, ones( size(X,1), 1 ), X );

%Iterate until all outliers are removed
while ( ~isempty( find( err > ERROR_THRESHOLD * avgerr, 1 ) ) )
    
    % Now calculate the least squares solution
    coeff = ( X' * X ) \ X' * Y;
    
    % Calculate the distance from each interpolated point to true point
    err = sum( ( Y - X * coeff ) .^ 2, 2 );
    avgerr = mean( err );
    
    % Anything that is more than three averages outside the mean then it is an
    % outlier and must be removed
    X = X ( err < ERROR_THRESHOLD * avgerr, : );
    Y = Y ( err < ERROR_THRESHOLD * avgerr, : );
    
end %while
