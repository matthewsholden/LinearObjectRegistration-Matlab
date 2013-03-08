%This function will match vectors in one set to vectors in another set in
%the least squares sense. Repeated matches implies an error.

%Parameter S: A smaller group of vectors which select partner from B
%Parameter B: A larger group of vectors, some of which are picked by S

%Return SM: Smaller group after matching
%Return BM: Bigger group whose elements are picked by corresponding smaller
%group elements
function [ SM, BM ] = SignatureMatch( S, B )

matches = zeros( numel(S), 1 );
problems = zeros( numel(S), 1 );

for i = 1:numel(S)
    
    minB = 1;
    
    for j = 1:numel(B)
        if ( norm( S{i}.signature - B{j}.signature ) < norm( S{i}.signature - B{minB}.signature ) )
            minB = j;
        end% if
    end % for
    
    for k = 1:i
        if ( matches(k) == minB )
            warning('Repeated matches');
            problems(k) = 1;
        end %if
    end %for
    
    if ( norm( S{i}.signature - B{minB}.signature ) > 1 )
        warning('Poor signature match');
    end %if
    
    matches(i) = minB;
    
end %for



% Remove all the points that are causing a problem (because we don't know
% the correspondence)
SM = cell( 0, 1 );
BM = cell( 0, 1 );

for i = 1:numel( S )
    if ( problems(i) == 0 )
        SM = cat( 1, SM, { S{i} } );
        BM = cat( 1, BM, { B{matches(i)} } );
    end %if
end % for