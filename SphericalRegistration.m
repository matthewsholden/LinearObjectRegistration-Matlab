% Compute the rigid registration between model data and empirical data
% using Arun's method

% Parameter GP: A cell array of points specified by the geometry
% Parameter RP: A cell array of points collected in the record log

% Return R: The best rotation
function R = SphericalRegistration( GP, RP )

GM = zeros( 3, 0 );
RM = zeros( 3, 0 );

for i=1:numel(GP)
    GM(:,i) = GP{i}.point;
end %for

for i=1:numel(RP)
    RM(:,i) = RP{i}.point;
end %for

% Arun's method

H = RM * GM';

[ U, ~, V ] = svd( H );

R = V * U';

