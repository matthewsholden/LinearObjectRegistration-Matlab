% Compute the translation between model data by checking the translation
% components

% Parameter GP: A cell array of points specified by the geometry
% Parameter RP: A cell array of points collected in the record log
% Parameter transform: Previous estimate of the transform

% Return newTranslation: The best translation (RecordLog to Geometry translation transform)
function newTranslation = TranslationalAdjustment( GP, RP, transform )

if ( nargin < 3 )
    transform = eye(3);
end

GM = zeros( 3, 0 );
RM = zeros( 3, 0 );

for i=1:numel(GP)
    GM(:,i) = GP{i}.point;
end %for

for i=1:numel(RP)
    transformedPoint = transform * [ RP{i}.point; 1 ];
    RM(:,i) = transformedPoint(1:3);
end %for

% Calculate the differences
differences = RM - GM;

% Translation vector
sumTranslation = zeros( 3, 1 );
sumMagnitudes = zeros( 3, 1 );
% Weight the request based on its direction (ie up-down requests only
% affect the up-down translation)

for i = 1:size( differences, 2 )    
    sumTranslation = sumTranslation + differences( :, i );
    sumMagnitudes = sumMagnitudes + abs( differences( :, i ) / norm( differences( :, i ) ) );
end

% Can we assume that all elements of requestMags are non-zero?
% This should be the case if there is any noise whatsoever
newTranslation = sumTranslation ./ sumMagnitudes;

% Unrotate (ie put back in the record log coordinate system)
newTranslation = transform(1:3,1:3) \ newTranslation;