% This function will take a record log of recorded hyperplanes, and find
% the associated points, using the points from the geometry

%Parameter GeometryFileName: The name of the file with the geometry specification
%Parameter RecordLogFileName: The name of the file with the record log
%Parameter noise: The amplitude of noise in the collected points

%Return ReferenceToRASTransform: The ReferenceToRASTransform
function RecordLogToGeometryTransform = LinearObjectRegistration( GeometryFileName, RecordLogFileName, noise )

DIRECTION_SCALE = 100;

% Read from file and recover all the hyperplanes
totalTic = tic;
[ GR GP GL GA ] = GeometryRead( GeometryFileName );

% Read from file the recordlog
% Pre-segmented
[ XYZ, RXYZ ] = RecordLogReadAnnotations( RecordLogFileName );
% Not pre-segmented
[ XYZ ] = RecordLogRead( RecordLogFileName );
[ RXYZ, XYZ, DOF ] = LinearObjectExtract( XYZ, size(GR,1) );

% Find equations of the linear objects
RR = cell( 0, 1 );
RP = cell( 0, 1 );
RL = cell( 0, 1 );
RA = cell( 0, 1 );
XYZR = cell( 0, 1 );
XYZP = cell( 0, 1 );
XYZL = cell( 0, 1 );
XYZA = cell( 0, 1 );

for i = 1:numel(XYZ)
    LO = LinearObjectLeastSquares( XYZ{i}, DOF(i) );
    
    if ( isa( LO, 'Point' ) )
        RP = cat( 1, RP, {LO} );
        XYZP = cat( 1, XYZP, { RemoveOutliers( LO, XYZ{i} ) } );
    elseif ( isa( LO, 'Line' ) )
        RL = cat( 1, RL, {LO} );
        XYZL = cat( 1, XYZL, { RemoveOutliers( LO, XYZ{i} ) } );
    elseif ( isa( LO, 'Plane' ) )
        RA = cat( 1, RA, {LO} );
        XYZA = cat( 1, XYZA, { RemoveOutliers( LO, XYZ{i} ) } );
    end %if
    
end %for

for i = 1:numel(RXYZ)
    
    LO = LinearObjectLeastSquares( RXYZ{i}, 0 );
    
    if ( isa( LO, 'Point' ) )
        RR = cat( 1, RR, { Reference( '1', LO.point ) } );
        XYZR = cat( 1, XYZR, { RemoveOutliers( LO, RXYZ{i} ) } );
    end %if
    
end %for

disp( [ 'References: ', num2str( size(RR,1) ) ] );
disp( [ 'Points: ', num2str( size(RP,1) ) ] );
disp( [ 'Lines: ', num2str( size(RL,1) ) ] );
disp( [ 'Planes: ', num2str( size(RA,1) ) ] );


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
XYZAM = XYZA;
XYZLM = XYZL;
XYZPM = XYZP;

% % For TESTING only!!!
% RecordLogToGeometryTransform = zeros( 4 );
% return;

%[ GAM, RAM, XYZAM ] = LinearObjectMatch( GR, RR, GA, RA, XYZA, noise );
%[ GLM, RLM, XYZLM ] = LinearObjectMatch( GR, RR, GL, RL, XYZL, noise );
%[ GPM, RPM, XYZPM ] = LinearObjectMatch( GR, RR, GP, RP, XYZP, noise );
RRM = RR;
GRM = GR;
XYZRM = XYZR;
% Note: The order of the recorded cell arrays is not changed, so XYZ cell
% arrays are already in the correct order


% Find the closest point for both sets
GeometryCentroid = LinearObjectCentroid( GPM, GLM, GAM );
RecordLogCentroid = LinearObjectCentroid( RPM, RLM, RAM );



% Now, subtract from each set the closest point (then, we need only
% rotational registration)
for i = 1:numel(GAM)
    GAM{i} = GAM{i}.Translate( - GeometryCentroid );
end %for
for i = 1:numel(GLM)
    GLM{i} = GLM{i}.Translate( - GeometryCentroid );
end %for
for i = 1:numel(GPM)
    GPM{i} = GPM{i}.Translate( - GeometryCentroid );
end %for
for i = 1:numel(GRM)
    GRM{i} = GRM{i}.Translate( - GeometryCentroid );
end %for

for i = 1:numel(RAM)
    RAM{i} = RAM{i}.Translate( - RecordLogCentroid );
end %for
for i = 1:numel(RLM)
    RLM{i} = RLM{i}.Translate( - RecordLogCentroid );
end %for
for i = 1:numel(RPM)
    RPM{i} = RPM{i}.Translate( - RecordLogCentroid );
end %for
for i = 1:numel(RRM)
    RRM{i} = RRM{i}.Translate( - RecordLogCentroid );
end %for

for i = 1:numel(XYZA)
    XYZAM{i} = bsxfun( @minus, XYZAM{i}, RecordLogCentroid' );
end %for
for i = 1:numel(XYZL)
    XYZLM{i} = bsxfun( @minus, XYZLM{i}, RecordLogCentroid' );
end %for
for i = 1:numel(XYZP)
    XYZPM{i} = bsxfun( @minus, XYZPM{i}, RecordLogCentroid' );
end %for
for i = 1:numel(XYZR)
    XYZRM{i} = bsxfun( @minus, XYZRM{i}, RecordLogCentroid' );
end %for



% Find the basePoints for everything
GABP = cell( 0, 1 );
GLBP = cell( 0, 1 );
GPBP = cell( 0, 1 );

RABP = cell( 0, 1 );
RLBP = cell( 0, 1 );
RPBP = cell( 0, 1 );

for i = 1:numel(GAM)
    GABP = cat( 1, GABP, { Point( GAM{i}.ProjectPoint( [0;0;0] ) ) } );
end %for
for i = 1:numel(GLM)
    GLBP = cat( 1, GLBP, { Point( GLM{i}.ProjectPoint( [0;0;0] ) ) } );
end %for
for i = 1:numel(GPM)
    GPBP = cat( 1, GPBP, { Point( GPM{i}.point ) } );
end %for

for i = 1:numel(RAM)
    RABP = cat( 1, RABP, { Point( RAM{i}.ProjectPoint( [0;0;0] ) ) } );
end %for
for i = 1:numel(RLM)
    RLBP = cat( 1, RLBP, { Point( RLM{i}.ProjectPoint( [0;0;0] ) ) } );
end %for
for i = 1:numel(RPM)
    RPBP = cat( 1, RPBP, { Point( RPM{i}.point ) } );
end %for


% Find the direction vectors for everything
GADV = cell( 0, 1 );
GLDV = cell( 0, 1 );

RADV = cell( 0, 1 );
RLDV = cell( 0, 1 );


% Observe that numel( GAM ) == numel( RAM )
for i = 1:numel(RAM)   
    
    % Produce the two candidate vectors
    RADV_Temp{1} = Point( RABP{i}.point + DIRECTION_SCALE * RAM{i}.GetNormal() );
    RADV_Temp{1} = RADV_Temp{1}.Signature( RRM );
    RADV_Temp{2} = Point( RABP{i}.point - DIRECTION_SCALE * RAM{i}.GetNormal() );
    RADV_Temp{2} = RADV_Temp{2}.Signature( RRM );
    
    GADV_Temp{1} = Point( GABP{i}.point + DIRECTION_SCALE * GAM{i}.GetNormal() );
    GADV_Temp{1} = GADV_Temp{1}.Signature( GRM );
    
    [ ~, RADV_Match ] = SignatureMatch( GADV_Temp, RADV_Temp );
    
    % Only add direction vector if there is a convincing match
    for j = 1:numel( GRM )
        dotCheck = dot( GAM{i}.GetNormal(), normc( GABP{i}.point - GRM{j}.point ) );
        if ( abs( dotCheck ) > 0.1 )
            RADV = cat( 1, RADV, { Point( RADV_Match{1}.point - RABP{i}.point ) } );
            GADV = cat( 1, GADV, { Point( DIRECTION_SCALE * GAM{i}.GetNormal() ) } );
            break;
        end
    end
    
end %for
for i = 1:numel(GLM)
    % Produce the two candidate vectors
    RLDV_Temp{1} = Point( RLBP{i}.point + DIRECTION_SCALE * RLM{i}.GetDirection() );
    RLDV_Temp{1} = RLDV_Temp{1}.Signature( RRM );
    RLDV_Temp{2} = Point( RLBP{i}.point - DIRECTION_SCALE * RLM{i}.GetDirection() );
    RLDV_Temp{2} = RLDV_Temp{2}.Signature( RRM );
    
    GLDV_Temp{1} = Point( GLBP{i}.point + DIRECTION_SCALE * GLM{i}.GetDirection() );
    GLDV_Temp{1} = GLDV_Temp{1}.Signature( GRM );
    
    [ ~, RLDV_Match ] = SignatureMatch( GLDV_Temp, RLDV_Temp );
    
    % Only add direction vector if there is a convincing match
    for j = 1:numel( GRM )
        dotCheck = dot( GLM{i}.GetDirection(), normc( GLBP{i}.point - GRM{j}.point ) );
        if (  abs( dotCheck ) > 0.1 )
            RLDV = cat( 1, RLDV, { Point( RLDV_Match{1}.point - RLBP{i}.point ) } );
            GLDV = cat( 1, GLDV, { Point( DIRECTION_SCALE * GLM{i}.GetDirection() ) } );
            break;       
        end
    end
    
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

%disp( [ 'Number Points: ', num2str(length(XYZP{1})), ', Number Lines: ', num2str(length(XYZL{1})), ', Number Planes: ', num2str(length(XYZA{1})) ] );


% Now, finally, perform point-to-point registration
estimatedRotation = SphericalRegistration( GeometryPoints, RecordLogPoints );
adjustedTranslation = zeros( size( RecordLogCentroid ) );
[ adjustedTranslation, estimatedRotation ] = LinearObjectICP( GPM, GLM, GAM, XYZPM, XYZLM, XYZAM, estimatedRotation );

RecordLogToGeometryTranslation = GeometryCentroid - estimatedRotation * ( RecordLogCentroid + adjustedTranslation );
RecordLogToGeometryTransform = eye(4);
RecordLogToGeometryTransform(1:3,1:3) = estimatedRotation;
RecordLogToGeometryTransform(1:3,4) = RecordLogToGeometryTranslation;

toc( totalTic );

