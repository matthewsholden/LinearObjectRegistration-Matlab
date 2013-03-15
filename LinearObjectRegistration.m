% This function will take a record log of recorded hyperplanes, and find
% the associated points, using the points from the geometry

%Parameter GeometryFileName: The name of the file with the geometry specification
%Parameter RecordLogFileName: The name of the file with the record log
%Parameter noise: The amplitude of noise in the collected points

%Return ReferenceToRASTransform: The ReferenceToRASTransform
function RecordLogToGeometryTransform = LinearObjectRegistration( GeometryFileName, RecordLogFileName, noise )

% Read from file and recover all the hyperplanes
[ GR GP GL GA ] = GeometryRead( GeometryFileName );

% Read from file the recordlog
% Pre-segmented
[ XYZ, RXYZ ] = RecordLogReadAnnotations( RecordLogFileName );
% Not pre-segmented
%[ XYZ ] = RecordLogRead( RecordLogFileName );
%[ XYZ, RXYZ ] = HyperplaneExtract( XYZ, size(GR,1) );

% Find equations of the hyperplanes
RR = cell( 0, 1 );
RP = cell( 0, 1 );
RL = cell( 0, 1 );
RA = cell( 0, 1 );

for i = 1:numel(XYZ)
    
    H = LinearObjectLeastSquares( XYZ{i}, noise );
    
    if ( isa( H, 'Point' ) )
        RP = cat( 1, RP, {H} );
    elseif ( isa( H, 'Line' ) )
        RL = cat( 1, RL, {H} );
    elseif ( isa( H, 'Plane' ) )
        RA = cat( 1, RA, {H} );
    end %if
    
end %for

for i = 1:numel(RXYZ)
    
    H = LinearObjectLeastSquares( RXYZ{i}, noise  );
    
    if ( isa( H, 'Point' ) )
        RR = cat( 1, RR, { Reference( '1', H.point ) } );
    end %if
    
end %for

% disp( [ 'References: ', num2str( size(RR,1) ) ] );
% disp( [ 'Points: ', num2str( size(RP,1) ) ] );
% disp( [ 'Lines: ', num2str( size(RL,1) ) ] );
% disp( [ 'Planes: ', num2str( size(RA,1) ) ] );


% Find the signatures for all planes, lines and points in both
for i = 1:numel(GA)
    GA{i} = GA{i}.Signature( GR );
end %for
for i = 1:numel(GL)
    GL{i} = GL{i}.Signature( GR );
end %for
for i = 1:numel(GP)
    GP{i} = GP{i}.Signature( GR );
end %for

for i = 1:numel(RA)
    RA{i} = RA{i}.Signature( RR );
end %for
for i = 1:numel(RL)
    RL{i} = RL{i}.Signature( RR );
end %for
for i = 1:numel(RP)
    RP{i} = RP{i}.Signature( RR );
end %for


% Do some matching
[ RAM, GAM ] = SignatureMatch( RA, GA );
[ RLM, GLM ] = SignatureMatch( RL, GL );
[ RPM, GPM ] = SignatureMatch( RP, GP );


% Find the closest point for both sets
GeometryCentroid = LinearObjectCentroid( GPM, GLM, GAM );
RecordLogCentroid = LinearObjectCentroid( RPM, RLM, RAM );


% Find the basePoints for everything
GABP = cell( 0, 1 );
GLBP = cell( 0, 1 );
GPBP = cell( 0, 1 );

RABP = cell( 0, 1 );
RLBP = cell( 0, 1 );
RPBP = cell( 0, 1 );

for i = 1:numel(GAM)
    GABP = cat( 1, GABP, { Point( GAM{i}.ProjectPoint( GeometryCentroid ) - GeometryCentroid ) } );
end %for
for i = 1:numel(GLM)
    GLBP = cat( 1, GLBP, { Point( GLM{i}.ProjectPoint( GeometryCentroid ) - GeometryCentroid ) } );
end %for
for i = 1:numel(GPM)
    GPBP = cat( 1, GPBP, { Point( GPM{i}.point - GeometryCentroid ) } );
end %for

for i = 1:numel(RAM)
    RABP = cat( 1, RABP, { Point( RAM{i}.ProjectPoint( RecordLogCentroid ) - RecordLogCentroid ) } );
end %for
for i = 1:numel(RLM)
    RLBP = cat( 1, RLBP, { Point( RLM{i}.ProjectPoint( RecordLogCentroid ) - RecordLogCentroid ) } );
end %for
for i = 1:numel(RPM)
    RPBP = cat( 1, RPBP, { Point( RPM{i}.point - RecordLogCentroid ) } );
end %for


% Find the direction vectors for everything
GADV = cell( 0, 1 );
GLDV = cell( 0, 1 );

RADV = cell( 0, 1 );
RLDV = cell( 0, 1 );


for i = 1:numel(GAM)
    GADV = cat( 1, GADV, { Point( GAM{i}.GetNormal() ) } );
end %for
for i = 1:numel(GLM)
    GLDV = cat( 1, GLDV, { Point( GLM{i}.GetDirection() ) } );
end %for

for i = 1:numel(RAM)
    % Produce the two candidate vectors
    RADV_Temp{1} = Point( RAM{i}.ProjectPoint( RecordLogCentroid ) + RAM{i}.GetNormal() );
    RADV_Temp{1} = RADV_Temp{1}.Signature( RR );
    RADV_Temp{2} = Point( RAM{i}.ProjectPoint( RecordLogCentroid ) - RAM{i}.GetNormal() );
    RADV_Temp{2} = RADV_Temp{2}.Signature( RR );
    
    GADV_Temp{1} = Point( GAM{i}.ProjectPoint( GeometryCentroid ) + GAM{i}.GetNormal() );
    GADV_Temp{1} = GADV_Temp{1}.Signature( GR );
    
    [ ~, RADV_Match ] = SignatureMatch( GADV_Temp, RADV_Temp );
    
    RADV = cat( 1, RADV, { Point( RADV_Match{1}.point - RAM{i}.ProjectPoint( RecordLogCentroid ) ) } );
end %for
for i = 1:numel(GLM)
        % Produce the two candidate vectors
    RLDV_Temp{1} = Point( RLM{i}.ProjectPoint( RecordLogCentroid ) + RLM{i}.GetDirection() );
    RLDV_Temp{1} = RLDV_Temp{1}.Signature( RR );
    RLDV_Temp{2} = Point( RLM{i}.ProjectPoint( RecordLogCentroid ) - RLM{i}.GetDirection() );
    RLDV_Temp{2} = RLDV_Temp{2}.Signature( RR );
    
    GLDV_Temp{1} = Point( GLM{i}.ProjectPoint( GeometryCentroid ) + GLM{i}.GetDirection() );
    GLDV_Temp{1} = GLDV_Temp{1}.Signature( GR );
    
    [ ~, RLDV_Match ] = SignatureMatch( GLDV_Temp, RLDV_Temp );
    
    RLDV = cat( 1, RLDV, { Point( RLDV_Match{1}.point - RLM{i}.ProjectPoint( RecordLogCentroid ) ) } );
end %for


% Add everything to the set of points for rigid registration
GeometryPoints = cell( 0, 1 );
RecordLogPoints = cell( 0, 1 );

GeometryPoints = cat( 1, GeometryPoints, GABP );
GeometryPoints = cat( 1, GeometryPoints, GLBP );
GeometryPoints = cat( 1, GeometryPoints, GPBP );
GeometryPoints = cat( 1, GeometryPoints, GADV );
GeometryPoints = cat( 1, GeometryPoints, GLDV );

RecordLogPoints = cat( 1, RecordLogPoints, RABP );
RecordLogPoints = cat( 1, RecordLogPoints, RLBP );
RecordLogPoints = cat( 1, RecordLogPoints, RPBP );
RecordLogPoints = cat( 1, RecordLogPoints, RADV );
RecordLogPoints = cat( 1, RecordLogPoints, RLDV );


% Now, finally, perform point-to-point registration
RecordLogToGeometryRotation = SphericalRegistration( GeometryPoints, RecordLogPoints );
RecordLogToGeometryTranslation = GeometryCentroid - RecordLogToGeometryRotation * RecordLogCentroid;
RecordLogToGeometryTransform = eye(4);
RecordLogToGeometryTransform(1:3,1:3) = RecordLogToGeometryRotation;
RecordLogToGeometryTransform(1:3,4) = RecordLogToGeometryTranslation;
