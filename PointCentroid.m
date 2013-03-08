% Calculate the centroid of a cell array of points

% Parameter P: A cell array of points

% Return centroid: The centroid of the cell array of points
function centroid = PointCentroid( P )

centroid = zeros( size( P{1} ) ); 

for i = 1:numel(P)    
    centroid = centroid + P{i};    
end %for

centroid = centroid / numel(P);