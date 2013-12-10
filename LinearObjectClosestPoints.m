% This function will find correspondence between collected points and
% linear objects (given we know which linear object each set of collected
% points belongs to)

%Parameter P: A cell array of points
%Parameter L: A cell array of lines
%Parameter A: A cell array of planes
%Parameter P_RLP: A cell array of collected points corresponding to points
%Parameter L_RLP: A cell array of collected points corresponding to lines
%Parameter A_RLP: A cell array of collected points corresponding to planes
%Parameter transform: A transform to apply to the collected points

%Return RecordLogPoints: Cell array of collected points
%Return GeometryPoints: Cell array of closest points on linear objects
function [ RecordLogPoints GeometryPoints ] = LinearObjectClosestPoints( P, L, A, P_RLP, L_RLP, A_RLP, transform )

% Speed this up by calculating the number of points initially
numPoints = 0;
for i = 1:numel( P_RLP )
  numPoints = numPoints + size( P_RLP{i}, 1 );
end %for
for i = 1:numel( L_RLP )
  numPoints = numPoints + size( L_RLP{i}, 1 );
end %for
for i = 1:numel( A_RLP )
  numPoints = numPoints + size( A_RLP{i}, 1 );
end %for

RecordLogPoints = cell( numPoints, 1 );
GeometryPoints = cell( numPoints, 1 );
currentIndex = 0;

% Find the closest model point to each transformed empirical point
for i = 1:numel( P_RLP )
    for j = 1:size( P_RLP{i}, 1 )
        currentIndex = currentIndex + 1;
        
        currentRLPoint = Point( P_RLP{i}( j, : )' );
        RecordLogPoints{ currentIndex } = currentRLPoint;
        
        currentGPoint = Point( P{i}.point ); % No ned to project here
        GeometryPoints{ currentIndex } = currentGPoint;
    end %for
end %for

for i = 1:numel( L_RLP )
    for j = 1:size( L_RLP{i}, 1 )
        currentIndex = currentIndex + 1;
        
        currentRLPoint = Point( L_RLP{i}( j, : )' );
        RecordLogPoints{ currentIndex } = currentRLPoint;
        
        transformedPoint = transform * [ L_RLP{i}( j, : )'; 1 ];
        currentGPoint = Point( L{i}.ProjectPoint( transformedPoint(1:3) ) );
        GeometryPoints{ currentIndex } = currentGPoint;
    end %for
end %for

for i = 1:numel( A_RLP )
    for j = 1:size( A_RLP{i}, 1 )
        currentIndex = currentIndex + 1;
        
        currentRLPoint = Point( A_RLP{i}( j, : )' );
        RecordLogPoints{ currentIndex } = currentRLPoint;
        
        transformedPoint = transform * [ A_RLP{i}( j, : )'; 1 ];
        currentGPoint = Point( A{i}.ProjectPoint( transformedPoint(1:3) ) );
        GeometryPoints{ currentIndex } = currentGPoint;
    end %for
end %for

