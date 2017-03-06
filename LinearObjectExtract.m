% This function will divide the registration tracking record into its
% corresponding part using pca

% Parameter XYZ: The tracking data
% Parameter NumRef: The number of reference points

% Return RXYZC: The observations corresponding to references
% Return XYZC: The observations corresponding to linear objects
% Return DOF: The number of dofs associated with each linear object
function [ RXYZC, XYZC, DOF ] = LinearObjectExtract( XYZ, NumRef )

MINIMUM_INTERVAL = 100;
TEST_INTERVAL = 20;
THRESHOLD = 0.1;

Seg = zeros( 0, 2 );
Dof = zeros( 0, 1 );

windowMin = 0;
windowMax = TEST_INTERVAL;
collecting = false;

eigenvalues = zeros( size(XYZ,1), 3 );

while ( windowMax < size(XYZ,1) )
    
    windowMin = windowMin + 1;
    windowMax = windowMin + TEST_INTERVAL;
    window = windowMin:windowMax;
    
    % Note that eigenvalues go smallest -> largest
    % But this is the case ONLY for symmetric matrices...
    eigenvalues( windowMax, : ) = eig( cov( XYZ( window,: ) ) );
    dof = length( find( eigenvalues( windowMax, : ) > THRESHOLD ) );
    
    if ( ~ collecting )
        startCollecting = windowMax;
    end %if
    
    if ( dof < 3 )
        collecting = true;
        continue;
    end %if
    
    endCollecting = windowMax;
    collecting = false;
    
    % Now, if we have found the end of the section, find the best number of
    % eigenvalues
    if ( ( endCollecting - startCollecting ) < MINIMUM_INTERVAL )
        continue;
    end %if
    
    % Find the lowest DOF subinterval larger than MINIMUM_INTERVAL
    % Search for the largest eigenvalues first
    for i = 3:-1:1
        
        dofEig = eigenvalues( startCollecting:endCollecting, i );
        dofIntervals = [ 1; find( dofEig > THRESHOLD ); endCollecting - startCollecting ];
        [ bestDofLength, bestDofInterval ] = max( diff( dofIntervals ) );
        
        if ( bestDofLength > MINIMUM_INTERVAL )
            Seg = cat( 1, Seg, startCollecting + [ dofIntervals(bestDofInterval) dofIntervals(bestDofInterval+1) ] );
            Dof = cat( 1, Dof, 3 - i );
            break;
        end %if
        
    end
    
end %while

XYZC_Temp = cell( size(Seg,1), 1 );
for i = 1:size(Seg,1)
    XYZC_Temp{i} = XYZ( Seg(i,1):Seg(i,2), : );
end %for

% Iterate backwards and assign references
XYZC = cell( 0, 1 );
RXYZC = cell( 0, 1 );
DOF = zeros( 0, 1 );

for i = 1:size(Seg,1)
    if ( size( RXYZC, 1 ) < NumRef && Dof(i) == 0 )
        RXYZC = cat( 1, XYZC_Temp{i}, RXYZC );
    else
        XYZC = cat( 1, XYZC_Temp{i}, XYZC );
        DOF = cat( 1, DOF, Dof(i) );
    end %if
end %for







