% This function finds the optimal matching pair between two sets of data
% (ie the single pair most likely to match)

%Parameter G: A cell array of geometry linear objects
%Parameter R: A cell array of recorded linear objects

%Return bestG: The index of the value in G which is part of the pair
%Return bestR: The index of the value in R which is part of the pair
function [ bestG, bestR ] = OptimalSinglePair( G, R )

% Compose into a matrix
matG = zeros( 0, length( G{1}.signature ) );
matR = zeros( 0, length( R{1}.signature ) );

for i = 1:numel(G)
    matG = cat( 1, matG, G{i}.signature' );
end

for i = 1:numel(R)
    matR = cat( 1, matR, R{i}.signature' );
end

% First, find the standard deviation in each dimension (using best match)
% Observe that for every element in P, there is a corresponding element in
% G
stdev = zeros( 1, size( matG, 2 ) );

for d = 1:size( matG, 2 )
    dist = pdist2( matR( :, d ), matG( :, d ) );
    bestMatch = min( dist, [], 2 );
    stdev(d) = sqrt( sum( bestMatch ) / size( matR, 1 ) );
end

% Assume each recorded point has a normal distribution about which its
% observations will be centred with the calculated stdev
% Find the recorded points with the highest probability of producing
% exactly one point and not producing the others
allProbs = zeros( size( matR, 1 ), 1 );
allIndices = zeros( size( matR, 1 ), 1 );

for i = 1 : size( matR, 1 )
    
    pointsProb = zeros( 1, size( matG, 1 ) );
    
    for j = 1 : size( matG, 1 )
        
        for d = 1 : size( matG, 2 )
            % This compute the log of the normal distribution
            currProb = - normlike( [ matR( i, d ), stdev( d ) ], matG( j, d ) );
        end
        
        pointsProb( j ) = pointsProb( j ) + currProb;
        
    end
    
    % Find the best
    [ bestPointsProb, bestIndex ] = max( pointsProb );
    % Ensure there is only one of the best (ignore duplicates)
    bestPointsProb = bestPointsProb(1);
    bestIndex = bestIndex(1);
    
    % If there's only one remaining, then we are done
    if ( numel( pointsProb ) == 1 )
       allProbs( i ) = bestPointsProb;
       allIndices( i ) = bestIndex;
       continue;
    end
    
    % Find the second best
    [ secondBestPointsProb, secondBestIndex ] = max( pointsProb( pointsProb ~= bestPointsProb ) );
    % Ensure there is only one of the second best (ignore duplicates)
    secondBestPointsProb = secondBestPointsProb(1);
    secondBestIndex = secondBestIndex(1);
    
    allProbs( i ) = bestPointsProb - secondBestPointsProb;
    allIndices( i ) = bestIndex;
    
end

[ ~, bestRIndex ] = max( allProbs );
bestR = bestRIndex;
bestG = allIndices( bestRIndex );

