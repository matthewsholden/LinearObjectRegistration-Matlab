% This function will evaulates the algorithm

% Parameter maxGeo: The maximum number of geometry features
% Parameter geoFileName: The file name to write the geometry to
% Parameter logFileName: The file name to write the record log
% Parameter randomFileName: The file name to write point with noise
% Parameter noise: A vector of noise amplitudes
% Parameter repeat: How many times to repeat calculate (so we can average)

% Return ER: The standard error in the rotation matrix
% Return ET: The standard error in the translation matrix
function [ ER, ET ] = LinearObjectRegistrationValidate( maxGeo, geoFileName, logFileName, randomFileName, noise, repeat )

% Initialize the error matrices
ER = zeros( repeat, length( noise ) );
ET = zeros( repeat, length( noise ) );

NUM_POINTS = 100;
RANGE = 100;

for i = 1:length( noise )
    for j = 1:repeat
        
        disp( [ 'Noise: ', num2str( noise(i) ), ', Iteration: ', num2str( j ) ] );
        
        % Generate random geometry
        
        NR = 2;
        NP = randi( maxGeo );
        NL = randi( maxGeo );
        NA = randi( maxGeo );
        
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
        
        RandomPoint( T, R, P, L, A, noise(i), NUM_POINTS, logFileName );
        NoisePoint = RandomNoise( noise(i), NUM_POINTS, randomFileName );
        
        
        % Calculate the transform using the hyperplane registration algorithm
        
        try
            T_Calc = LinearObjectRegistration( geoFileName, logFileName, EstimateNoise( NoisePoint ) );
        catch exception
            err = lasterror;
            disp(err);
            disp(err.message);
            disp(err.stack);
            disp(err.identifier);
            continue;
        end
        
        % Determine the standard error of rotation and translation
        
        IT = inv(T);
        
        % ER(j,i) = sqrt( sum( sum( ( IT(1:3,1:3) - T_Calc(1:3,1:3) ) .^ 2 ) ) / 9 );
        ER(j,i) = CompareRotations( IT, T_Calc );
        ET(j,i) = norm( IT(1:3,4) - T_Calc(1:3,4) );
        
        disp( [ 'ER: ', num2str( ER(j,i) ), ', ET: ', num2str( ET(j,i) ) ] );
        
        
    end % for
end %for
