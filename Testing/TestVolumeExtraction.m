

% Let's create a volume with a line in it
volSize = 50;
threshold = 3;
volume = zeros( volSize, volSize, volSize );

endPoint1 = randi( volSize, 1, 3 );
endPoint2 = randi( volSize, 1, 3 );
direction = endPoint1 - endPoint2;
direction = direction / norm( direction );

for i = 1:volSize
    for j = 1:volSize
        for k = 1:volSize
            
            point = [ i, j, k ];
            vector = point - endPoint1;
            orthVector = vector - dot( direction, vector ) * direction;
            distance = norm( orthVector );
            
            if ( distance <= threshold )
               volume( i, j, k ) = 1; 
            end
            
        end
    end
end


% Ok, test the extraction algorithm
