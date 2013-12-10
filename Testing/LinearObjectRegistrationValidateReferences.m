% This function will evaulates the algorithm

% Parameter maxGeo: The maximum number of geometry features
% Parameter geoFileName: The file name to write the geometry to
% Parameter logFileName: The file name to write the record log
% Parameter randomFileName: The file name to write point with noise
% Parameter noise: A vector of noise amplitudes
% Parameter repeat: How many times to repeat calculate (so we can average)

% Return fails: The number of times the matching failed
function fails = LinearObjectRegistrationValidateReferences( geo, geoFileName, logFileName, randomFileName, noise, repeat )

% Initialize the error matrices
fails = zeros( repeat, length( geo ) );

NUM_POINTS = 100;
RANGE = 100;

for i = 1:length( geo )
    for j = 1:repeat
        
        disp( [ 'References: ', num2str( geo(i) ), ', Iteration: ', num2str( j ) ] );
        
        % Generate random geometry
        
        NR = geo(i);
        NP = randi( 4 );
        NL = randi( 4 );
        NA = randi( 4 );
        
        [ R P L A ] = RandomGeometry( NR, NP, NL, NA, geoFileName );
        
        
        % Generate a random transform by algorithm:
        
        % 1. Generate a random matrix with each element on (0,1)
        % 2. Calculate the svd of that matrix
        % 3. Return U * V'
        DET = -1;
        
        while ( DET < 0 ) % Make sure det(Rotation) = +1
            T = eye(4);
            [ U, ~, V ] = svd( rand(3,3) );
            T(1:3,1:3) = U * V';
            T(1:3,4) = RANGE - 2 * RANGE * rand(3,1);
            DET = det( T(1:3,1:3) );
        end % while
        
        %T = eye(4);
        
        % Generate random transformed collected points
        
        RandomPoint( T, R, P, L, A, noise, NUM_POINTS, logFileName );
        NoisePoint = RandomNoise( noise, NUM_POINTS, randomFileName );
        
        
        % Calculate the transform using the hyperplane registration algorithm
        
        try
            T_Calc = LinearObjectRegistration( geoFileName, logFileName, EstimateNoise( NoisePoint ) );
        catch exception
            if ( strcmp( exception.identifier, 'Matching' ) )
                fails( j, i ) = 1;
            end
        end
        
    end % for
end %for
