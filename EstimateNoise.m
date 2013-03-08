% This function will be used to get an estimate of the noise associated
% with the tracking (that way, we can ensure we use good eigenvalue
% thresholds for pca)

% Parameter XYZ: The position data of a tracking fixed point

% Return NA: The estimated amplitude of noise
function NA = EstimateNoise( XYZ )

% Move the data so the mean is zero
MXYZ = bsxfun( @minus, XYZ, mean(XYZ,1) );

% Simply estimate noise as the standard error
% Assume isotropic noise 
NA = sqrt( sum( sum( MXYZ .^ 2 ) ) / numel( XYZ ) );