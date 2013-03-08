% This function will calculate the transform between two ordered point sets
% via the algorithm from Horn

% Parameter P1: A cell array of points in one coordinate frame
% Parameter P2: A cell array of point in the other coordinate frame

% Return T: The transformation matrix between Frame1ToFrame2Transform
function Frame2ToFrame1Transform = RigidRegistration( P1, P2 )

R1 = zeros( numel(P1), 3 ); 
R2 = zeros( numel(P2), 3 ); 

for i=1:numel(P1)
    R1(i,:) = P1{i}.point;
end %for

for i=1:numel(P2)
    R2(i,:) = P2{i}.point;
end %for

% Subtract the means
Q1 = bsxfun( @minus, R1, mean(R1,1) );
Q2 = bsxfun( @minus, R2, mean(R2,1) );

% Find the "covariance" matrix
H = Q2' * Q1;

% Horn -------------------------------------------------------------------

%Calculate the N matrix
N = zeros(4,4);

N(1,1) = H(1,1) + H(2,2) + H(3,3);
N(1,2) = H(2,3) - H(3,2);
N(1,3) = H(3,1) - H(1,3);
N(1,4) = H(1,2) - H(2,1);

N(2,1) = H(2,3) - H(3,2);
N(2,2) = H(1,1) - H(2,2) - H(3,3);
N(2,3) = H(1,2) + H(2,1);
N(2,4) = H(3,1) + H(1,3);

N(3,1) = H(3,1) - H(1,3);
N(3,2) = H(1,2) + H(2,1);
N(3,3) = - H(1,1) + H(2,2) - H(3,3);
N(3,4) = H(2,3) + H(3,2);

N(4,1) = H(1,2) - H(2,1);
N(4,2) = H(3,1) + H(1,3);
N(4,3) = H(2,3) + H(3,2);
N(4,4) = - H(1,1) - H(2,2) + H(3,3);


% Now, find the largest eigenvalue eigenvector
[evector, evalue] = eig(N);
evalue = diag(evalue);
[ ~, maxIx ] = max(evalue);
q = evector( :, maxIx ); %This is assuming that first element is real part


% Finally, compute the rotation from the quaternion
%Normalize quaternion
q = q / norm(q);
q = q * sign(q(1));

%The first row of the matrix
R(1,1)=q(2)^2-q(3)^2-q(4)^2+q(1)^2;
R(1,2)=2*q(2)*q(3)-2*q(4)*q(1);
R(1,3)=2*q(2)*q(4)+2*q(3)*q(1);

%The second row of the matrix
R(2,1)=2*q(2)*q(3)+2*q(4)*q(1);
R(2,2)=-q(2)^2+q(3)^2-q(4)^2+q(1)^2;
R(2,3)=2*q(3)*q(4)-2*q(2)*q(1);

%The third row of the matrix
R(3,1)=2*q(2)*q(4)-2*q(3)*q(1);
R(3,2)=2*q(3)*q(4)+2*q(2)*q(1);
R(3,3)=-q(2)^2-q(3)^2+q(4)^2+q(1)^2;


%Calculate the translation
T = mean( R1, 1 ) - mean ( R2 * R', 1 );

% Now, the final matrix is
Frame2ToFrame1Transform = eye(4);
Frame2ToFrame1Transform(1:3,1:3) = R;
Frame2ToFrame1Transform(1:3,4) = T;