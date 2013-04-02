%This function will read an xml file with the recorded registration
%transforms

%Parameter fileName: The name of the XML file to read

%Return XYZ: A cell array of record logs each of which is a hyperplane
%Return RXYZ: A cell array of reference record logs
function [ XYZ, RXYZ ] = RecordLogReadAnnotations( fileName )

%Get a reference to the XML file
XML = xmlread(fileName);
%Get a reference to the root element
TransformRecorderLog = XML.getDocumentElement();
%Get an array of child nodes
Records = TransformRecorderLog.getChildNodes();

TX = zeros(0,1);
X = zeros(0,3);

TM = zeros(0,1);
M = cell(0,1);


% Apparently only every other child node has anything in it
for i = 1:2:( Records.getLength - 1 )
    
    Current = Records.item(i).getAttributes();
    
    if ( strcmp( Records.item(i).getNodeName(), 'log' ) )
        
        time = 0;
        point = [0 0 0];
        message = '';
        type = '';
        
        for j = 0:( Current.getLength - 1 )
            
            if ( strcmp( Current.item(j).getName(), 'type' ) )
                type = Current.item(j).getValue();
            end %if
            
            if ( strcmp( Current.item(j).getName(), 'transform' ) )
                matrix = str2num( Current.item(j).getValue() );
                point(1) = matrix(4);
                point(2) = matrix(8);
                point(3) = matrix(12);
            end %if
            
            if ( strcmp( Current.item(j).getName(), 'message' ) )
                message = Current.item(j).getValue();
            end %if
            
            if ( strcmp( Current.item(j).getName(), 'TimeStampSec' ) )
                time = time + str2num( Current.item(j).getValue() );
            end %if
            
            if ( strcmp( Current.item(j).getName(), 'TimeStampNSec' ) )
                time = time + 1e-9 * str2num( Current.item(j).getValue() );
            end %if
            
        end %for
        
        if ( strcmp( type, 'transform' ) )
            TX = cat( 1, TX, time );
            X = cat( 1, X, point );
        end %if
        
        if ( strcmp( type, 'message' ) )
            TM = cat( 1, TM, time );
            M = cat( 1, M, message );
        end %if
        
    end %if
    
    
end %for


% Count how many cells we need
cellCount = 0;
refCount = 0;
for j = 1:size(TM,1)
    if ( strcmp( M(j) , 'on' ) )
        cellCount = cellCount + 1;
    end %if
    if ( strcmp( M(j) , 'reference' ) )
        refCount = refCount + 1;
    end %if
end %for

RXYZ = cell( refCount, 1 );
XYZ = cell( cellCount, 1 );

for i = 1:cellCount
    XYZ{i} = zeros( 0, 3 );
end %for

for i = 1:refCount
    RXYZ{i} = zeros( 0, 3 );
end %for


% Now, break up X into cell arrays based on the messages
for i = 1:size(X,1)
    
    %Find the largest smaller message timestamp
    cellCount = 0;
    refCount = 0;
    for j = 1:size(TM,1)
        if ( strcmp( M(j) , 'on' ) )
            cellCount = cellCount + 1;
        end %if
        if ( strcmp( M(j) , 'reference' ) )
            refCount = refCount + 1;
        end %if
        if ( j == size(TM,1) || TM(j+1) > TX(i) )
            if ( TM(j) > TX(i) )
                cellCount = 0;
                refCount = 0;
            end %if
            if ( strcmp( M(j) , 'off' ) )
                cellCount = 0;
                refCount = 0;
            end %if
            if ( strcmp( M(j) , 'on' ) )
                refCount = 0;
            end %if
            if ( strcmp( M(j) , 'reference' ) )
                cellCount = 0;
            end %if
            break;
        end %if
    end %for
    
    %Now, add to the appropriate cell array
    if ( cellCount > 0 )
        XYZ{cellCount} = cat( 1, XYZ{cellCount}, X(i,:) );
    end %if
    
    if ( refCount > 0 )
        RXYZ{refCount} = cat( 1, RXYZ{refCount}, X(i,:) );
    end %if
    
end %for