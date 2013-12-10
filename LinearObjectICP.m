% This function will perform spherical registration with unknown point
% correspondence by the iterative closest point algorithm. With an initial
% guess required. Assume no translation required.
% We want to find R such that P,L,A = R * RecordLogPoints

%Parameter P: A cell array of points
%Parameter L: A cell array of lines
%Parameter A: A cell array of planes
%Parameter P_RLP: A matrix of collected points corresponding to points
%Parameter L_RLP: A matrix of collected points corresponding to lines
%Parameter A_RLP: A matrix of collected points corresponding to planes
%Parameter initRotation: An initial guess at the spherical registration

function [ adjustedTranslation, estimatedRotation, rmsError ] = LinearObjectICP( P, L, A, P_RLP, L_RLP, A_RLP, initRotation )

THRESHOLD = 1e-3;
error = zeros( 0, 1 );

estimatedRotation = initRotation; % This is the total rotation for the registration
adjustedTranslation =  [ 0; 0; 0 ]; % This is the adjustment we have to make (from the centroid translation)


% Iterative until the error measure converges
while ( size(error,1) < 2 || abs( error(end) - error(end-1) ) > THRESHOLD )
    
    %Find the closest points
    translationPart = eye( 4 );
    translationPart( [ 13 14 15 ] ) = -adjustedTranslation;
    rotationPart = eye(4);
    rotationPart( 1:3, 1:3 ) = estimatedRotation;
    transform = rotationPart * translationPart;
    [ RecordLogPoints, GeometryPoints ] = LinearObjectClosestPoints( P, L, A, P_RLP, L_RLP, A_RLP, transform );
    
    % Calculate the translation adjustment
    % Need to be incremental because the translation is applied before the
    % rotation
    adjustedTranslation = adjustedTranslation + TranslationalAdjustment( GeometryPoints, RecordLogPoints, transform );
    
    
    % Find the closest points
    translationPart = eye( 4 );
    translationPart( [ 13 14 15 ] ) = -adjustedTranslation;
    rotationPart = eye(4);
    rotationPart( 1:3, 1:3 ) = estimatedRotation;
    transform = rotationPart * translationPart;
    [ RecordLogPoints, GeometryPoints ] = LinearObjectClosestPoints( P, L, A, P_RLP, L_RLP, A_RLP, transform );
    
    % Calculate the rotation estimation
    % Do not need to be incremental here because the rotation is applied
    % after the translation
    estimatedRotation = SphericalRegistration( GeometryPoints, RecordLogPoints, -adjustedTranslation );
    
    
    % Find the closest points
    translationPart = eye( 4 );
    translationPart( [ 13 14 15 ] ) = -adjustedTranslation;
    rotationPart = eye(4);
    rotationPart( 1:3, 1:3 ) = estimatedRotation;
    transform = rotationPart * translationPart;
    [ RecordLogPoints, GeometryPoints ] = LinearObjectClosestPoints( P, L, A, P_RLP, L_RLP, A_RLP, transform );
    
    % Calculate the error
    currError = 0;
    for i = 1:numel(RecordLogPoints)
        transformedPoint = transform * [ RecordLogPoints{i}.point; 1 ];
        currentGPoint = GeometryPoints{i}.point;
        currError = currError + sum ( ( currentGPoint - transformedPoint(1:3) ) .^ 2 );
    end %for
    error = cat( 1, error, sqrt( currError / numel( RecordLogPoints ) ) );
    
    %adjustedTranslation
    %estimatedRotation
    %error( end )
    
end %for

rmsError = error( end );
rmsError
