% Given a linear object and a set of points, remove outliers from the set
% of points

% Parameter LO: The linear object
% Parameter points: A set of points (possibly containing outliers)

% Return filterPoints: The set of points with no outliers
function filterPoints = RemoveOutliers( LO, points )

NUMSTDEV = 5;
THRESHOLD = 1e-6; % Deal with the case of small noise

% Iterate until no more outliers exist
changed = true;
filterPoints = points;

while ( changed )
    
    distances = zeros( size( filterPoints, 1 ), 1 );
    
    % For each point, calculate the distance to the liner object
    for i = 1 : size( filterPoints, 1 )        
        distances(i) = LO.DistanceToPoint( filterPoints(i,:)' );
    end %for
    
    stdev = sqrt( sum( distances .^ 2 ) );
    
    filterPoints = filterPoints( distances < NUMSTDEV * stdev | distances < THRESHOLD, : );
    
    if ( numel(distances) ~= numel( distances < THRESHOLD * stdev | distances < THRESHOLD ) )
        changed = true;
    else
        changed = false;
    end %if
       
end %while