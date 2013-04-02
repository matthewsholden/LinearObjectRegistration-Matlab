% Evaluate how good a registration is in the least squares sense

%Parameter geoFile: The name of the geometry file
%Parameter logFile: The name of the record log file
%Parameter transform: The transform such that geo = transform * record

%Return avgError: The average error in the registration
function avgError = EvaluateRegistration( GeometryFileName, RecordLogFileName, transform )

% Read from file and recover all the hyperplanes
[ ~, GP, GL, GA ] = GeometryRead( GeometryFileName );

% Read from file the recordlog
% Pre-segmented
[ XYZ, ~ ] = RecordLogReadAnnotations( RecordLogFileName );
% Not pre-segmented
%[ XYZ ] = RecordLogRead( RecordLogFileName );
%[ XYZ, RXYZ ] = HyperplaneExtract( XYZ, size(GR,1) );


avgError = 0;
Count = 0;

for i = 1:numel(XYZ) 
    for j = 1:size( XYZ{i}, 1 )
        
        TransformedPoint = transform * [ XYZ{i}(j,:)'; 1 ];
        TransformedPoint = TransformedPoint(1:3);
        
        minError = Inf;
        
        for k = 1:numel(GA)
            currError = GA{k}.DistanceToPoint( TransformedPoint );
            if ( currError < minError )
                minError = currError;
            end %if
        end %for
        
        for k = 1:numel(GL)
            currError = GL{k}.DistanceToPoint( TransformedPoint );
            if ( currError < minError )
                minError = currError;
            end %if
        end %for
        
        for k = 1:numel(GP)
            currError = GP{k}.DistanceToPoint( TransformedPoint );
            if ( currError < minError )
                minError = currError;
            end %if
        end %for
        
        avgError = avgError + minError;
        Count = Count + 1;

    end %for
end %for
avgError = avgError / Count;