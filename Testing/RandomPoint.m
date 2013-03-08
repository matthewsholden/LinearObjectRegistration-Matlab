% Put random points on planes for testing

% Parameter T: A random transformation matrix
% Parameter R: A cell array of references
% Parameter P: A cell array of points
% Parameter L: A cell array of lines
% Parameter A: A cell array of planes
% Parameter noise: The amplitude of noise for each point
% Parameter numPoints: The number of random points to put on each plane
% Parameter fileName: Write the random points in TransformRecorderLog file
% format to this file

% Return RandomPoints: A cell array of the random points
function RandomPoints = RandomPoint( T, R, P, L, A, noise, numPoints, fileName )

% Range of parameters
RANGE = 100;

% Setup the XML document
docNode = com.mathworks.xml.XMLUtils.createDocument('TransformRecorderLog');
docRootNode = docNode.getDocumentElement();

RandomPoints = cell( 0, 1 );
time = 0;


% First, get random point on referece
for i = 1:numel(R)
    
    % Add a message
    message = docNode.createElement('log');
    message.setAttribute( 'type', 'message' );
    message.setAttribute( 'TimeStampSec', num2str(time) );
    message.setAttribute( 'TimeStampNSec', num2str(0) );
    message.setAttribute( 'message', 'reference' );
    docRootNode.appendChild( message );
    
    for j = 1:numPoints
        
        % Now, find the base point
        point = R{i}.point;
        
        % Add some random noise to this point
        point = point + random( 'norm', 0, noise , size(point) );   
        point = T * [point; 1];
        RandomPoints = cat( 1, RandomPoints, point );
        
        % Add this point to file
        transform = docNode.createElement('log');
        transform.setAttribute( 'type', 'transform' );
        transform.setAttribute( 'DeviceName', 'Tool' );
        transform.setAttribute( 'TimeStampSec', num2str(time) );
        transform.setAttribute( 'TimeStampNSec', num2str(0) );
        transform.setAttribute( 'transform', num2str( [ 0 0 0 point(1) 0 0 0 point(2) 0 0 0 point(3) 0 0 0 1 ] ) );
        docRootNode.appendChild( transform );
        
        time = time + 1;
        
    end % for
    
    % Add a message
    message = docNode.createElement('log');
    message.setAttribute( 'type', 'message' );
    message.setAttribute( 'TimeStampSec', num2str(time) );
    message.setAttribute( 'TimeStampNSec', num2str(0) );
    message.setAttribute( 'message', 'off' );
    docRootNode.appendChild( message );
    
    time = time + 1;
    
end %for


% First, get random point on point
for i = 1:numel(P)
    
    % Add a message
    message = docNode.createElement('log');
    message.setAttribute( 'type', 'message' );
    message.setAttribute( 'TimeStampSec', num2str(time) );
    message.setAttribute( 'TimeStampNSec', num2str(0) );
    message.setAttribute( 'message', 'on' );
    docRootNode.appendChild( message );
    
    for j = 1:numPoints
        
        % Generate the random points on the plane A
        point = P{i}.point;

        % Add some random noise to this point
        point = point + random( 'norm', 0, noise , size(point) );   
        point = T * [point; 1];
        RandomPoints = cat( 1, RandomPoints, point );
        
        % Add this point to file
        transform = docNode.createElement('log');
        transform.setAttribute( 'type', 'transform' );
        transform.setAttribute( 'DeviceName', 'Tool' );
        transform.setAttribute( 'TimeStampSec', num2str(time) );
        transform.setAttribute( 'TimeStampNSec', num2str(0) );
        transform.setAttribute( 'transform', num2str( [ 0 0 0 point(1) 0 0 0 point(2) 0 0 0 point(3) 0 0 0 1 ] ) );
        docRootNode.appendChild( transform );
        
        time = time + 1;
        
    end % for
    
    % Add a message
    message = docNode.createElement('log');
    message.setAttribute( 'type', 'message' );
    message.setAttribute( 'TimeStampSec', num2str(time) );
    message.setAttribute( 'TimeStampNSec', num2str(0) );
    message.setAttribute( 'message', 'off' );
    docRootNode.appendChild( message );
    
    time = time + 1;
    
end %for


% First, get random point on line
for i = 1:numel(L)
    
    % Add a message
    message = docNode.createElement('log');
    message.setAttribute( 'type', 'message' );
    message.setAttribute( 'TimeStampSec', num2str(time) );
    message.setAttribute( 'TimeStampNSec', num2str(0) );
    message.setAttribute( 'message', 'on' );
    docRootNode.appendChild( message );
    
    for j = 1:numPoints
        
        % Generate the random points on the plane A
        randParam1 = RANGE - 2 * randi( RANGE * RANGE ) / RANGE;
        
        % Now, move from the base point along the end points by params
        point = L{i}.endPoint1 + randParam1 * L{i}.GetDirection();
        
        % Add some random noise to this point
        point = point + random( 'norm', 0, noise , size(point) );
        point = T * [point; 1];
        RandomPoints = cat( 1, RandomPoints, point );
        
        % Add this point to file
        transform = docNode.createElement('log');
        transform.setAttribute( 'type', 'transform' );
        transform.setAttribute( 'DeviceName', 'Tool' );
        transform.setAttribute( 'TimeStampSec', num2str(time) );
        transform.setAttribute( 'TimeStampNSec', num2str(0) );
        transform.setAttribute( 'transform', num2str( [ 0 0 0 point(1) 0 0 0 point(2) 0 0 0 point(3) 0 0 0 1 ] ) );
        docRootNode.appendChild( transform );
        
        time = time + 1;
        
    end % for
    
    % Add a message
    message = docNode.createElement('log');
    message.setAttribute( 'type', 'message' );
    message.setAttribute( 'TimeStampSec', num2str(time) );
    message.setAttribute( 'TimeStampNSec', num2str(0) );
    message.setAttribute( 'message', 'off' );
    docRootNode.appendChild( message );
    
    time = time + 1;
    
end %for



% First, get random point on plane
for i = 1:numel(A)
    
    % Add a message
    message = docNode.createElement('log');
    message.setAttribute( 'type', 'message' );
    message.setAttribute( 'TimeStampSec', num2str(time) );
    message.setAttribute( 'TimeStampNSec', num2str(0) );
    message.setAttribute( 'message', 'on' );
    docRootNode.appendChild( message );
    
    for j = 1:numPoints
        
        % Generate the random points on the plane A
        randParam1 = RANGE - 2 * randi( RANGE * RANGE ) / RANGE;
        randParam2 = RANGE - 2 * randi( RANGE * RANGE ) / RANGE;
        
        % Now, move from the base point along the end points by params
        point = A{i}.basePoint + randParam1 * ( A{i}.basePoint - A{i}.endPoint1 ) + randParam2 * ( A{i}.basePoint - A{i}.endPoint2 );
        
        % Add some random noise to this point
        point = point + random( 'norm', 0, noise , size(point) );
        point = T * [point; 1];
        RandomPoints = cat( 1, RandomPoints, point );
        
        % Add this point to file
        transform = docNode.createElement('log');
        transform.setAttribute( 'type', 'transform' );
        transform.setAttribute( 'DeviceName', 'Tool' );
        transform.setAttribute( 'TimeStampSec', num2str(time) );
        transform.setAttribute( 'TimeStampNSec', num2str(0) );
        transform.setAttribute( 'transform', num2str( [ 0 0 0 point(1) 0 0 0 point(2) 0 0 0 point(3) 0 0 0 1 ] ) );
        docRootNode.appendChild( transform );
        
        time = time + 1;
        
    end % for
    
    % Add a message
    message = docNode.createElement('log');
    message.setAttribute( 'type', 'message' );
    message.setAttribute( 'TimeStampSec', num2str(time) );
    message.setAttribute( 'TimeStampNSec', num2str(0) );
    message.setAttribute( 'message', 'off' );
    docRootNode.appendChild( message );
    
    time = time + 1;
    
end %for

xmlwrite( fileName, docNode );

