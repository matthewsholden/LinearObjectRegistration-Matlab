%This function will read an xml file specifying the hyperplanes, and
%produce the hyperplane objects

%Parameter fileName: The name of the XML file to read

%Return R: A cell array of reference points
%Return P: A cell array of points
%Return L: A cell array of lines
%Return A: A cell array of planes
function [ R P L A ] = GeometryRead( fileName )

%Get a reference to the XML file 
XML = xmlread(fileName);
%Get a reference to the root element
Geometry = XML.getDocumentElement();
%Get an array of child nodes
Hyperplanes = Geometry.getChildNodes();

R = cell( 0, 1 );
P = cell( 0, 1 );
L = cell( 0, 1 );
A = cell( 0, 1 );




% Apparently only every other child node has anything in it
for i = 1:2:( Hyperplanes.getLength - 1 )
    
    Current = Hyperplanes.item(i).getAttributes();
    
    if ( strcmp( Hyperplanes.item(i).getNodeName(), 'Reference' ) )
        
        name = '';
        point = '';
                
        for j = 0:( Current.getLength - 1 )
            
            if ( strcmp( Current.item(j).getName(), 'Name' ) )
                name = Current.item(j).getValue();
            end %if
            if ( strcmp( Current.item(j).getName(), 'Point' ) )
                point = str2num( Current.item(j).getValue() )';
            end %if
                    
        end %for
        
        R_Temp = { Reference( name, point ) };
        R = cat( 1, R, R_Temp );
    
    end %if
    
    
    if ( strcmp( Hyperplanes.item(i).getNodeName(), 'Point' ) )
                
        for j = 0:( Current.getLength - 1 )
            
            if ( strcmp( Current.item(j).getName(), 'Point' ) )
                point = str2num( Current.item(j).getValue() )';
            end %if
                    
        end %for
        
        P_Temp = { Point( point ) };
        P = cat( 1, P, P_Temp );
    
    end %if
    
    if ( strcmp( Hyperplanes.item(i).getNodeName(), 'Line' ) )
        
        endPoint1 = '';
        endPoint2 = '';
                
        for j = 0:( Current.getLength - 1 )
            
            if ( strcmp( Current.item(j).getName(), 'EndPoint1' ) )
                endPoint1 = str2num( Current.item(j).getValue() )';
            end %if
            if ( strcmp( Current.item(j).getName(), 'EndPoint2' ) )
                endPoint2 = str2num( Current.item(j).getValue() )';
            end %if
                    
        end %for
        
        L_Temp = { Line( endPoint1, endPoint2 ) };
        L = cat( 1, L, L_Temp );
    
    end %if
    
    
    if ( strcmp( Hyperplanes.item(i).getNodeName(), 'Plane' ) )
        
        basePoint = '';
        endPoint1 = '';
        endPoint2 = '';
                
        for j = 0:( Current.getLength - 1 )
            
            if ( strcmp( Current.item(j).getName(), 'BasePoint' ) )
                basePoint = str2num( Current.item(j).getValue() )';
            end %if
            if ( strcmp( Current.item(j).getName(), 'EndPoint1' ) )
                endPoint1 = str2num( Current.item(j).getValue() )';
            end %if
            if ( strcmp( Current.item(j).getName(), 'EndPoint2' ) )
                endPoint2 = str2num( Current.item(j).getValue() )';
            end %if
                    
        end %for
        
        A_Temp = { Plane( basePoint, endPoint1, endPoint2 ) };
        A = cat( 1, A, A_Temp );
    
    end %if
    
    
end %for