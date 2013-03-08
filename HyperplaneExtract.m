% This function will divide the registration tracking record into its
% corresponding part using pca

% Parameter XYZ: The tracking data
% Parameter NumRef: The number of reference points

% Return XYZ: The observations corresponding to hyperplanes
% Return XYZ: The observations corresponding to references
function [ XYZC, RXYZC ] = HyperplaneExtract( XYZ, NumRef )

MINIMUM_RECORDS = 40;
THROW = 15;
THRESHOLD = 5;

% Iterate until we have a good candidate
Seg = zeros( 0, 2 );
DOF = zeros( 0, 1 );
windowMin = 0;
windowMax = MINIMUM_RECORDS;

while ( windowMax < size(XYZ,1) )
    
    windowMin = windowMin + 1;
    windowMax = windowMin + MINIMUM_RECORDS;
    window = windowMin:windowMax;
    
    eigenvalues = eig( cov( XYZ( window,: ) ) );
    
    if ( length( find( eigenvalues > THRESHOLD ) ) > 2 )
        continue;
    end %if
    
    windowMin = windowMin + THROW;
    window = windowMin:windowMax;    
    eigenvalues = eig( cov( XYZ( window,: ) ) );
    
    % Now, expand the window until we are out of range
    while ( length( find( eigenvalues > THRESHOLD ) ) <= 2 && windowMax < size(XYZ,1) )
        
        windowMax = windowMax + 1;
        window = windowMin:windowMax;
        
        eigenvalues = eig( cov( XYZ( window,: ) ) );
        
    end %while
    
    windowMax = windowMax - THROW;
    window = windowMin:windowMax;    
    eigenvalues = eig( cov( XYZ( window,: ) ) );
    
    dof = length( find( eigenvalues > THRESHOLD ) );    
    
    Seg = cat( 1, Seg, [ windowMin, windowMax ] );
    DOF = cat( 1, DOF, dof );
    
    windowMin = windowMax;
    windowMax = windowMin + MINIMUM_RECORDS;
    
end %while

XYZC_Temp = cell( size(Seg,1), 1 );
for i = 1:size(Seg,1)
    XYZC_Temp{i} = XYZ( Seg(i,1):Seg(i,2), : );
end %for

% Iterate backwards and assign references
XYZC = cell( 0, 1 );
RXYZC = cell( 0, 1 );

for i = size(Seg,1):-1:1
    if ( size( RXYZC, 1 ) < NumRef && DOF(i) == 0 )
        RXYZC = cat( 1, XYZC_Temp{i}, RXYZC );
    else
        XYZC = cat( 1, XYZC_Temp{i}, XYZC );
    end %if
end %for






