% Compare the rotations of two transforms

% Parameter T1: One transform
% Parameter T2: Another transform

% Return phi: The angle of rotation of their quotient
function phi = CompareRotations( T1, T2 )

R1 = T1( 1:3, 1:3 );
R2 = T2( 1:3, 1:3 );

R = R1' * R2;

[ phi, ~ ] = r2aa( R );
