% This function will take a record log of recorded hyperplanes, and find
% the associated points, using the points from the geometry

%Parameter GeometryFileName: The name of the file with the geometry specification
%Parameter RecordLogFileName: The name of the file with the record log
%Parameter noise: The amplitude of noise in the collected points

%Return ReferenceToRASTransform: The ReferenceToRASTransform
function ReferenceToRASTransform = HyperplaneRegistration( GeometryFileName, RecordLogFileName, noise )

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
    
    H = HyperplaneLeastSquares( XYZ{i}, noise );
    
    if ( isa( H, 'Point' ) )
        RP = cat( 1, RP, {H} );
    elseif ( isa( H, 'Line' ) )
        RL = cat( 1, RL, {H} );
    elseif ( isa( H, 'Plane' ) )
        RA = cat( 1, RA, {H} );
    end %if
    
end %for

for i = 1:numel(RXYZ)
    
    H = HyperplaneLeastSquares( RXYZ{i}, noise  );
    
    if ( isa( H, 'Point' ) )
        RR = cat( 1, RR, { Reference('1',H.point) } );
    end %if
    
end %for

% disp( [ 'References: ', num2str( size(RR,1) ) ] );
% disp( [ 'Points: ', num2str( size(RP,1) ) ] );
% disp( [ 'Lines: ', num2str( size(RL,1) ) ] );
% disp( [ 'Planes: ', num2str( size(RA,1) ) ] );


% Dont' find line of intersection for parallel planes
THRESHOLD = 0.1;

% Now, find lines from planes
for i = 1:numel(GA)
    for j = 1:(i-1)
        if ( norm( cross( GA{i}.GetNormal(), GA{j}.GetNormal ) ) > THRESHOLD )
            GL_Temp = { GA{i}.GetIntersection( GA{j} ) };
            GL = cat( 1, GL, GL_Temp );
        end %if
    end %for
end %for
for i = 1:numel(RA)
    for j = 1:(i-1)
        if ( norm( cross( RA{i}.GetNormal(), RA{j}.GetNormal ) ) > THRESHOLD )
            RL_Temp = { RA{i}.GetIntersection( RA{j} ) };
            RL = cat( 1, RL, RL_Temp );
        end %if
    end %for
end %for

% Find the signatures for all lines and points in both
for i = 1:numel(GL)
    GL{i} = GL{i}.Signature( GR );
end %for
for i = 1:numel(GP)
    GP{i} = GP{i}.Signature( GR );
end %for
for i = 1:numel(RL)
    RL{i} = RL{i}.Signature( RR );
end %for
for i = 1:numel(RP)
    RP{i} = RP{i}.Signature( RR );
end %for


% Do some matching
[ RLM, GLM ] = SignatureMatch( RL, GL );
[ RPM, GPM ] = SignatureMatch( RP, GP );


% Find the closest point for both sets
GeometryClosestPoint = PointLineIntersection( GPM, GLM );
RecordLogClosestPoint = PointLineIntersection( RPM, RLM );


% Parameterize the geometry lines
for i = 1:numel(GLM)
    GLM{i} = GLM{i}.Parameterize( GeometryClosestPoint );
end %for


% Now, deparameterize the record log lines
RLMDP1 = cell( 0, 1 );
RLMDP2 = cell( 0, 1 );
for i = 1:numel(RLM)
   
    RLMDP1_Temp = RLM{i}.Deparameterize( RecordLogClosestPoint, GLM{i}.param1, GLM{i}.param2 );
    RLMDP1_Temp = RLMDP1_Temp.Signature( RR );
    RLMDP1 = cat( 1, RLMDP1, { RLMDP1_Temp } );
    
    RLMDP2_Temp = RLM{i}.Deparameterize( RecordLogClosestPoint, -GLM{i}.param1, -GLM{i}.param2 );
    RLMDP2_Temp = RLMDP2_Temp.Signature( RR );
    RLMDP2 = cat( 1, RLMDP2, { RLMDP2_Temp } );
    
end %for


% Collect the corresponding deparameterization by matching signatures
for i = 1:numel(RLM)
    
    RLMDPP = cell( 0, 1 );
    GLMPP = cell( 0, 1 );
    
    RLMDPP = cat( 1, RLMDPP, { Point( RLMDP1{i}.endPoint1 ) } );
    RLMDPP = cat( 1, RLMDPP, { Point( RLMDP1{i}.endPoint2 ) } );
    RLMDPP = cat( 1, RLMDPP, { Point( RLMDP2{i}.endPoint1 ) } );
    RLMDPP = cat( 1, RLMDPP, { Point( RLMDP2{i}.endPoint2 ) } );
    
    RLMDPP{1} = RLMDPP{1}.Signature( RR );
    RLMDPP{2} = RLMDPP{2}.Signature( RR );
    RLMDPP{3} = RLMDPP{3}.Signature( RR );
    RLMDPP{4} = RLMDPP{4}.Signature( RR );
    
    GLMPP = cat( 1, GLMPP, { Point( GLM{i}.endPoint1 ) } );
    GLMPP = cat( 1, GLMPP, { Point( GLM{i}.endPoint2 ) } );
    
    GLMPP{1} = GLMPP{1}.Signature( GR );
    GLMPP{2} = GLMPP{2}.Signature( GR );
    
    [ ~, RLMDPPM ] = SignatureMatch( GLMPP, RLMDPP );
    
    RLM{i} = Line( RLMDPPM{1}.point, RLMDPPM{2}.point );
    
end %for


%Now add the points from the line to the set of all points
for i = 1:numel(GLM)
    GPM = cat( 1, GPM, { Point( GLM{i}.endPoint1 ) } );
    GPM = cat( 1, GPM, { Point( GLM{i}.endPoint2 ) } );
end %for
for i = 1:numel(RLM)
    RPM = cat( 1, RPM, { Point( RLM{i}.endPoint1 ) } );
    RPM = cat( 1, RPM, { Point( RLM{i}.endPoint2 ) } );
end %for



% Now, finally, perform point-to-point registration
ReferenceToRASTransform = RigidRegistration( GPM, RPM );
