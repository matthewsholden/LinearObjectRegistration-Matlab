% This function will create some random linear objects with references to
% be collected experimentally

% Parameter numExp: The number of experiments we wish to do
% Parameter candidateLO: A cell array of available linear objects
% Parameter candidateR: A cell array of available references
% Parameter numLO: The number of linear objects to pick
% Parameter numR: The number of references to pick

% Return LOR: A cell array of strings with the objects (including references) to be used
function [ LOR ] = ExperimentalCollection( numExp, candidateLO, candidateR, numLO, numR )


LOR = cell( 1, numExp );

for n = 1:numExp
    
    referenceString = '';
    
    for i = 1:numR
        
        for j = 1:numel( candidateR )
            
            currR = candidateR{j}( randi( length( candidateR{j} ) ) );
            while( ~isempty( strfind( referenceString, currR ) ) )
                currR = candidateR{j}( randi( length( candidateR{j} ) ) );
            end
            
            referenceString = [ referenceString, currR ];
            
        end
        
    end
    
    
    lorString = '';
    
    for i = 1:numLO
        
        for j = 1:numel( candidateLO )
            
            currLO = candidateLO{j}( randi( length( candidateLO{j} ) ) );
            while( ~isempty( strfind( referenceString, currLO ) ) )
                currLO = candidateLO{j}( randi( length( candidateLO{j} ) ) );
            end
            
            lorString = [ lorString, currLO ];
            
        end
        
    end
    
    LOR{n} = [ referenceString, lorString ];
    
end