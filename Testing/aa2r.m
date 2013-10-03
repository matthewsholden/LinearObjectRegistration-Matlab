% Convert an axis angle representation of a rotation to a rotation matrix

function R = aa2r( phi, k )

% By the course notes, k is normalized, but let us double-check (naively)
k = k / norm(k);

K = v2s( k );
I = eye(3);

R = I + sin( phi ) * K + ( 1 - cos( phi ) ) * K * K;