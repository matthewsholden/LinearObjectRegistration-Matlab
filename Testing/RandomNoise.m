% This function will generate a random file which would simulate possible
% noise calibration

% Parameter noise: The amplitude the noise has
% Parameter numPoints: The number of observation points
% Parameter fileName: The name of the file to write the noise record log

% Return XYZ: An observation matrix
function XYZ = RandomNoise( noise, numPoints, fileName )

% The range of possible means
RANGE = 100;

XYZ = zeros( 0, 3 );
time = 0;

% Setup the XML document
docNode = com.mathworks.xml.XMLUtils.createDocument('TransformRecorderLog');
docRootNode = docNode.getDocumentElement();

centroid = zeros( 3, 1 );
centroid = RANGE - 2 * randi( RANGE * RANGE, size(centroid) ) / RANGE;

for j = 1:numPoints

    % Add some random noise to this point
    point = centroid + random( 'norm', 0, noise, size(centroid) );
    
    XYZ = cat( 1, XYZ, point' );
    
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

xmlwrite( fileName, docNode );