% Given a linear object and a set of points, remove outliers from the set
% of points

% Parameter LO: The linear object
% Parameter points: The set of points (possibly containing outliers)

% Return filterPoints: The set of points with no outliers
function filterPoints = RemoveOutliers( LO, points )

THRESHOLD = 5;

% Iterate until no more outliers exist
changed = true;
distances = zeros( size( points, 1 ), 1 );
filterPoints = points;

while ( changed )
    
    % For each point, calculate the distance to the liner object
    for i = 1 : size( filterPoints, 1 )        
        distances(i) = LO.DistanceToPoint( filterPoints(i)' );
    end %for
    
    stdev = std( distances );
    
    filterPoints = filterPoints( distances < THRESHOLD * stdev, : );
    
end %while