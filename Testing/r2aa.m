% Convert a rotation matrix to the axis-angle representation (numerically
% stable)

function [ phi, k ] = r2aa( R )

% First, calculate the angle
c = - ( trace(R) - 3 ) / 2;
phi = acos( 1 - c );

% Note that if the angle is zero, then there is no rotation (pick any axis)
if ( phi == 0 )
    k = [ 1; 0; 0 ];
    return;
end

K2 = ( ( R + R' ) / 2 - eye(3) ) / c;

kx2 = K2(1,1) + 1;
ky2 = K2(2,2) + 1;
kz2 = K2(3,3) + 1;

% First possible combination of signs
if ( kx2 >= ky2 && kx2 >= kz2 )
    kxs1 = sqrt( kx2 );
    kys1 = sign( K2(1,2) ) * sqrt( ky2 );
    kzs1 = sign( K2(1,3) ) * sqrt( kz2 );
elseif ( ky2 >= kx2 && ky2 >= kz2 )
    kxs1 = sign( K2(2,1) ) * sqrt( ky2 );
    kys1 = sqrt( ky2 );
    kzs1 = sign( K2(2,3) ) * sqrt( kz2 );
elseif ( kz2 >= kx2 && kz2 >= ky2 )
    kxs1 = sign( K2(3,1) ) * sqrt( ky2 );
    kys1 = sign( K2(3,2) ) * sqrt( kz2 );
    kzs1 = sqrt( kz2 );
end

ks1 = [ kxs1; kys1; kzs1 ];

% Second possible combination of signs
kxs2 = - kxs1;
kys2 = - kys1;
kzs2 = - kzs1;

ks2 = [ kxs2; kys2; kzs2 ];

% Test the two possible combinations of signs
Rs1 = aa2r( phi, ks1 );
Rs2 = aa2r( phi, ks2 );

% Find the closest rotation matrix
if ( norm( R - Rs1 ) < norm( R - Rs2 ) )
    k = ks1;
else
    k = ks2;
end
