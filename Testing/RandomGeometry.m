% Create a random set of linear object geometry for testing

% Parameter NR: Number of references
% Parameter NP: Number of points
% Parameter NL: Number of lines
% Parameter NA: Number of planes
% Parameter fileName: The file to write the geometry to

% Return R P L A: Cell arrays of geometry features
function [ R P L A ] = RandomGeometry( NR, NP, NL, NA, fileName )

RANGE = 100;

R = cell( 0, 1 );
P = cell( 0, 1 );
L = cell( 0, 1 );
A = cell( 0, 1 );

% Just pick random points in the range

for i = 1:NR
    point = RANGE - 2 * RANGE * rand(3,1);
    R = cat( 1, R, { Reference( 'Reference', point ) } );
end %for

for i = 1:NP
    point = RANGE - 2 * RANGE * rand(3,1);
    P = cat( 1, P, { Point( point ) } );
end %for

for i = 1:NL
    endPoint1 = RANGE - 2 * RANGE * rand(3,1);
    endPoint2 = RANGE - 2 * RANGE * rand(3,1);
    L = cat( 1, L, { Line( endPoint1, endPoint2 ) } );
end %for

for i = 1:NA
    basePoint = RANGE - 2 * RANGE * rand(3,1);
    endPoint1 = RANGE - 2 * RANGE * rand(3,1);
    endPoint2 = RANGE - 2 * RANGE * rand(3,1);
    A = cat( 1, A, { Plane( basePoint, endPoint1, endPoint2 ) } );
end %for

% Now, write it all to file

% Setup the XML document
docNode = com.mathworks.xml.XMLUtils.createDocument('Geometry');
docRootNode = docNode.getDocumentElement();

for i = 1:NR
    reference = docNode.createElement('Reference');
    reference.setAttribute( 'Name', [ 'Reference' , num2str(i) ] );
    reference.setAttribute( 'BasePoint', num2str( R{i}.point' ) );
    docRootNode.appendChild( reference );
end %for

for i = 1:NP
    point = docNode.createElement('Point');
    point.setAttribute( 'Name', [ 'Point' , num2str(i) ] );
    point.setAttribute( 'BasePoint', num2str( P{i}.point' ) );
    docRootNode.appendChild( point );
end %for

for i = 1:NL
    line = docNode.createElement('Line');
    line.setAttribute( 'Name', [ 'Line' , num2str(i) ] );
    line.setAttribute( 'BasePoint', num2str( L{i}.endPoint1' ) );
    line.setAttribute( 'EndPoint', num2str( L{i}.endPoint2' ) );
    docRootNode.appendChild( line );
end %for

for i = 1:NA
    plane = docNode.createElement('Plane');
    plane.setAttribute( 'Name', [ 'Plane' , num2str(i) ] );
    plane.setAttribute( 'BasePoint', num2str( A{i}.basePoint' ) );
    plane.setAttribute( 'EndPoint1', num2str( A{i}.endPoint1' ) );
    plane.setAttribute( 'EndPoint2', num2str( A{i}.endPoint2' ) );
    docRootNode.appendChild( plane );
end %for


% And create the file
xmlwrite( fileName, docNode );

