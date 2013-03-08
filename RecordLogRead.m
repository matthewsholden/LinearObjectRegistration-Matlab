%This function will read an xml file with the recorded registration
%transforms

%Parameter fileName: The name of the XML file to read

%Return XYZ: The xyz observations (no rotation)
function [ X ] = RecordLogRead( fileName )

%Get a reference to the XML file
XML = xmlread(fileName);
%Get a reference to the root element
TransformRecorderLog = XML.getDocumentElement();
%Get an array of child nodes
Records = TransformRecorderLog.getChildNodes();

TX = zeros(0,1);
X = zeros(0,3);


% Apparently only every other child node has anything in it
for i = 1:2:( Records.getLength - 1 )
    
    Current = Records.item(i).getAttributes();
    
    if ( strcmp( Records.item(i).getNodeName(), 'log' ) )
        
        time = 0;
        point = [0 0 0];
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
        
    end %if
    
    
end %for
