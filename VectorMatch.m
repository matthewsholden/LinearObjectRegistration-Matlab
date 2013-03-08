%This function will match vectors in one set to vectors in another set in
%the least squares sense. Repeated matches implies an error.

%Parameter S: A smaller group of vectors which select partner from B
%Parameter B: A larger group of vectors, some of which are picked by A

%Return matches: A vector indicating which element in B, was picked by A
function matches = VectorMatch( S, B )

matches = zeros( numel(S), 1 );
problems = zeros( numel(S), 1 );

for i = 1:numel(S)
    
    minB = 1;
    
    for j = 1:numel(B)
        if ( norm( S{i} - B{j} ) < norm( S{i} - minB ) )
            minB = j;
        end% if
    end % for
    
    for k = 1:i
        if ( matches(k) == minB )
            warning('Repeated matches');
            problems(k) = 1;
        end %if
    end %for
    
    matches(i) = minB;
    
end %for

% Remove all the points that are causing a problem (because we don't know
% the correspondence)
matches( problems == 1 ) = 0;