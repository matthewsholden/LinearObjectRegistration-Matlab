% This function finds the optimal point to project onto a linear object and
% computes that projction

% Parameter R: The cell array of reference points to project
% Parameter LO: The linear object onto which the points should be projected

% Return PR: The reference projected onto the linear object
function PR = OptimalProjection( R, LO )

bestProjection = zeros( size( R{1}.point ) );
bestDistance = 0;

for i = 1:numel(R)
   
    %Project the current reference onto the linear object
    currPoint = LO.ProjectPoint( R{i}.point );
    
    % Find the reference with the most distinct projection
    currDistance = Inf;
    for j = 1:numel(R)
       if ( norm( R{j}.point - currPoint ) < currDistance )
          currDistance = norm( R{j}.point - currPoint );
       end        
    end
    
    
    % Check if its better than any previous projection
    if ( currDistance > bestDistance )
       bestDistance = currDistance; 
       bestProjection = currPoint;
    end
    
    
end

% Now, convert the best projected point to a reference
currRef = Reference( 'ProjectedReference', bestProjection );

% And add to the set of references
PR = cat( 1, R, { currRef } );