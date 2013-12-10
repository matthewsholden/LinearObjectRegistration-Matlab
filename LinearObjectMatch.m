% This function will compute the linear object matches using the updated
% algorithm

% Parameter GR: The geometry cell array of references
% Parameter RR: The recorded cell array of references
% Parameters GLO: The geometry cell array of linear objects
% Parameters RLO: The recorded cell array of linear objects
% Parameters RXYZ: The recorded cell array of collected points
% Parameter noise: The noise asociated with data recording

% Return GMLO: The matched cell array of geometry linear objects
% Return RMLO: The matched cell array of recorded linear objects
% Return RMXYZ: The matched cell array of collected points
function [ GMLO, RMLO, RMXYZ ] = LinearObjectMatch( GR, RR, GLO, RLO, RXYZ, noise )

GMLO = cell( 0, 1 );
RMLO = cell( 0, 1 );
RMXYZ = cell( 0, 1 );

while ( numel( RLO ) > 0 && numel( GLO ) > 0 )
    
    % Calculate the signatures for each linear object
    for i = 1:numel( GLO )
        GLO{i} = GLO{i}.Signature( GR );
    end
    for i = 1:numel( RLO )
        RLO{i} = RLO{i}.Signature( RR );
    end
        
    % Find the optimal pair
    [ optIndexG, optIndexR ] = OptimalSinglePair( GLO, RLO, noise );
    
    % Project all of the current references onto the optimal linear object
    % Note that "OptimalProjection" already cats it
    GR = OptimalProjection( GR, GLO{ optIndexG } );
    RR = OptimalProjection( RR, RLO{ optIndexR } );
    
    % Add optimal pair to matched linear objects    
    GMLO = cat( 1, GMLO, { GLO{ optIndexG } } );
    RMLO = cat( 1, RMLO, { RLO{ optIndexR } } );
    RMXYZ = cat( 1, RMXYZ, { RXYZ{ optIndexR } } );
    
    % Remove optimal pair from the previous cell arrays
    GLO = cat( 1, GLO( 1:optIndexG - 1 ), GLO( optIndexG + 1:end ) );
    RLO = cat( 1, RLO( 1:optIndexR - 1 ), RLO( optIndexR + 1:end ) );
    RXYZ = cat( 1, RXYZ( 1:optIndexR - 1 ), RXYZ( optIndexR + 1:end ) );
    
end