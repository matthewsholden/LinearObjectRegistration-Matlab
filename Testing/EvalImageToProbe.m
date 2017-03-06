
% Load the cross wire point buffer to find the actual cross-wire point
% relative to the references
CrossWirePointBuffer = AscTrackToData( 'S:\data\LinearObjectRegistration\Feb11_2014\Lego\Crosswire_Pointing_TransformBuffer.xml', { 'StylusTipToReference' } );
CrossWirePointBuffer = CrossWirePointBuffer{1};
CrossWirePointGroundTruth = [ mean( CrossWirePointBuffer.X( :, 1:3 ) ), 1 ]';

% Load the cross wire scan buffer
ScanTools = { 'ProbeToTracker', 'ReferenceToTracker', 'FiducialToImage' };
CrossWireScanBuffer = AscTrackToData( 'S:\data\LinearObjectRegistration\Feb11_2014\Lego\Crosswire_Scanning_TransformBuffer.xml', ScanTools );
ProbeToTrackerBuffer = CrossWireScanBuffer{ 1 };
ReferenceToTrackerBuffer = CrossWireScanBuffer{ 2 };
FiducialToImageBuffer = CrossWireScanBuffer{ 3 };

% Import that image to probe calibration results
% % Test
% ImageToProbeBuffer = [
% 0.00049 0.06280 0.00975 54.029 -0.05793 0.0022 0.02219 26.420 0.02205 -0.01140 0.05807 15.247 0 0 0 1;
% -0.00117 0.06205 0.01258 55.131 -0.06764 0.00450 0.01197 29.386 0.01290 -0.01306 0.06390 19.596 0 0 0 1;
% 0.00102 0.06046 0.01060 54.480 -0.06454 0.00040 0.01509 27.106 0.01574 -0.01057 0.06119 14.705 0 0 0 1;
% 0.00124 0.06090 0.01245 54.06 -0.06134 -0.00076 0.01198 26.45 0.01201 -0.01251 0.05990 17.53 0 0 0 1;
% -0.00089 0.06078 0.00985 54.974 -0.06415 0.00026 0.01285 27.135 0.01355 -0.00980 0.06147 16.009 0 0 0 1
% ];

% Landmark
ImageToProbeBuffer = [
-0.00047	0.06071	0.00951	54.894	-0.06464	0.0007	0.0138	27.736	0.01455	-0.00953	0.06162	15.087	0	0	0	1;
-0.00075	0.06057	0.01005	55.118	-0.06418	0.00078	0.01353	27.5	0.01429	-0.0101	0.06131	15.139	0	0	0	1;
-0.00041	0.06066	0.00974	55.035	-0.0644	0.00091	0.01363	27.714	0.01434	-0.00981	0.06148	15.049	0	0	0	1;
-0.00049	0.06065	0.00983	55.181	-0.06454	0.00092	0.01325	27.634	0.01397	-0.00988	0.06157	15.188	0	0	0	1;
-0.0004	0.06078	0.00945	54.921	-0.06435	0.00077	0.01322	27.57	0.01388	-0.00949	0.06157	15.25	0	0	0	1;
-0.00024	0.06074	0.00934	55.096	-0.06467	0.00106	0.01356	27.679	0.01426	-0.00943	0.06169	15.05	0	0	0	1;
-0.0003	0.06069	0.00951	55.01	-0.06421	0.00111	0.01312	27.424	0.01376	-0.00962	0.06146	15.263	0	0	0	1;
-0.00021	0.0607	0.00952	54.935	-0.06437	0.00115	0.01335	27.609	0.014	-0.00964	0.06153	15.231	0	0	0	1;
-0.00035	0.06065	0.00976	55.243	-0.06454	0.00103	0.01354	27.548	0.01425	-0.00984	0.06155	15.275	0	0	0	1;
-0.00035	0.06071	0.0094	55.092	-0.06464	0.00099	0.01376	27.647	0.01449	-0.00948	0.06164	15.086	0	0	0	1;
-0.00041	0.06068	0.00942	55.043	-0.0644	0.00106	0.0141	27.567	0.01484	-0.00954	0.06147	14.802	0	0	0	1;
0.00004	0.06073	0.00926	54.985	-0.0645	0.00122	0.01407	27.642	0.01474	-0.00941	0.06155	14.904	0	0	0	1
];

% % Linear Object Registration
% ImageToProbeBuffer = [
% -0.00121	0.06071	0.0097	55.111	-0.06409	0.00034	0.01282	27.093	0.01356	-0.00965	0.06143	15.945	0	0	0	1;
% -0.00178	0.06061	0.00989	55.363	-0.06426	0.0001	0.01317	27.416	0.01406	-0.00978	0.06143	16.797	0	0	0	1;
% -0.00154	0.06063	0.00967	55.269	-0.0641	0.00024	0.01321	27.27	0.01404	-0.00961	0.06137	16.563	0	0	0	1;
% -0.00131	0.06064	0.00961	55.357	-0.06408	0.00047	0.01375	26.807	0.01457	-0.00951	0.06131	16.098	0	0	0	1;
% -0.00147	0.06059	0.00961	55.12	-0.06431	0.00046	0.01356	26.908	0.01443	-0.00958	0.06143	16.158	0	0	0	1;
% -0.00139	0.06061	0.00958	55.472	-0.06443	0.00052	0.01374	27.06	0.01461	-0.00957	0.06148	16.235	0	0	0	1;
% -0.00116	0.06073	0.00953	55.179	-0.06432	0.00034	0.01324	27.242	0.01402	-0.00948	0.06153	16.036	0	0	0	1;
% -0.00133	0.06064	0.00966	55.274	-0.06448	0.00048	0.01308	27.094	0.01391	-0.00962	0.06158	16.649	0	0	0	1;
% -0.00148	0.06068	0.00978	55.387	-0.06404	0.0003	0.01253	27.145	0.01331	-0.00972	0.06142	17.031	0	0	0	1;
% -0.00147	0.06058	0.00972	55.065	-0.06439	0.00049	0.01308	26.978	0.01392	-0.00968	0.0615	16.468	0	0	0	1;
% -0.00184	0.06053	0.00982	55.286	-0.06387	0.00042	0.01338	26.622	0.01426	-0.00981	0.06119	16.77	0	0	0	1;
% -0.00166	0.06056	0.0098	55.023	-0.06429	0.00029	0.01352	26.977	0.01442	-0.00973	0.06139	16.404	0	0	0	1
% ];


% Count how many iterations we require
numScans = size( FiducialToImageBuffer.X, 1 );
numCalibrations = size( ImageToProbeBuffer, 1 );

CrossWirePointDifferences = zeros( numCalibrations, numScans );

for i = 1:numCalibrations
    
    ImageToProbeMatrix = reshape( ImageToProbeBuffer( i, : ), 4, 4 )';
    
    for j = 1:numScans
        FiducialToImageMatrix = dofToMatrix( FiducialToImageBuffer.X( j, : ) );
        ProbeToTrackerMatrix = dofToMatrix( ProbeToTrackerBuffer.X( j, : ) );
        TrackerToReferenceMatrix = inv( dofToMatrix( ReferenceToTrackerBuffer.X( j, : ) ) );
        
        CrossWirePointEstimate = TrackerToReferenceMatrix * ProbeToTrackerMatrix * ImageToProbeMatrix * FiducialToImageMatrix * [ 0; 0; 0; 1 ];
        
        CrossWirePointDifferences( i, j ) = norm( CrossWirePointGroundTruth - CrossWirePointEstimate );
    end
end
