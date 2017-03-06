% Eigendecomposition matching test

% fCal
% Ras = [
%     119.00 20.05 39.96;
%     119.00 20.05 4.85;
%     119.00 4.89 4.93;
%     119.00 5.08 45.00;
%     1.00 20.09 4.74;
%     1.00 15.05 45.08;
%     1.00 4.94 45.06;
%     1.00 4.86 4.92;
%     ];
%
% Ref = [
%     -5.38 8.04 33.44;
%     -5.32 9.22 -3.86;
%     10.09 6.48 0.56;
%     9.66 8.39 40.67;
%     -6.22 -112.05 -4.87;
%     -1.57 -112.10 35.52;
%     8.23 -113.16 34.60;
%     9.02 -114.34 -6.79;
%     ];

% % Lumbar
% Ras = [
%     -69.00 -75.97 -28.57
%     -63.52 -76.18 -44.00
%     -18.75 -20.86 -44.00
%     27.46 -1.00 42.34
%     27.49 -1.00 112.22
%     -52.63 -1.00 112.71
%     ];
%
% Ref = [
%     3.43 3.08 -9.69
%     3.40 -10.75 -4.98
%     58.94 -12.36 39.45
%     78.33 76.74 87.05
%     79.38 146.93 86.55
%     79.45 144.74 6.82
%     ];

% Test
Ras = [
    0 0 0;
    0 0 1;
    0 1 0;
    100 0 0;
    ];

Ref = [     
    0 0 0;
    0 0 1;
    0 1 0;
    ];

%currPerm = randperm( size( Ref, 1 ) );
currPerm = [ 1 2 3 ];
RefPerm = Ref( currPerm, : );

% Calculate the adjacency matrices
RasAdj = pdist2( Ras, Ras );
RefAdj = pdist2( RefPerm, RefPerm );

%RasAdj = RasAdj / max( max( RasAdj ) );
%RefAdj = RefAdj / max( max( RefAdj ) );

% Calculate the degree matrices
RasDeg = diag( sum( RasAdj, 2 ) );
RefDeg = diag( sum( RefAdj, 2 ) );

% Calculate the Laplacian matrices
RasLap = RasDeg - RasAdj;
RefLap = RefDeg - RefAdj;

[ uRas, sRas, vRas ] = svd( RasAdj );
[ uRef, sRef, vRef ] = svd( RefAdj );

% Chop the largest one down to size
eigDist = pdist2( diag( sRas ), diag( sRef ) );
eigMatch = Hungarian( eigDist );

if ( size( Ras, 1 ) > size( Ref, 1 ) )
    uRasChop = uRas * eigMatch;
    uRefChop = uRef;
end
if ( size( Ref, 1 ) > size( Ras, 1 ) )
    uRasChop = uRas;
    uRefChop = uRef * eigMatch';
end

matchMatrix = abs( uRasChop ) * abs( uRefChop' );

%matchMatrix = horzcat( matchMatrix, ones( size( matchMatrix, 1 ), maxSize - size( matchMatrix, 2 ) ) );
%matchMatrix = vertcat( matchMatrix, ones( maxSize - size( matchMatrix, 1 ), size( matchMatrix, 2 ) ) );

FinalAssignment = Hungarian( 1 - matchMatrix );

Quality = norm( RefAdj - FinalAssignment' * RasAdj * FinalAssignment, 'fro' );