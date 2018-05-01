function analysisSettings = getAnalysisSettings

%% Analysis Settings
% Load Ball Settings 
settings = ballSettings; 

% Downsample factor for downsampling velocity and displacement
analysisSettings.dsFactor = 400;
analysisSettings.dsPhaseShift = 0;

% Downsampled sample rate
analysisSettings.dsRate = 100; 

% For line plot, amount of time before and after stimulus to measure
% displacement
analysisSettings.timeBefore = 0.32;
analysisSettings.stopLatency = 0.12;
analysisSettings.velAvgTime = 0.5;

% Bin size for forward speed histogram
binSize = settings.mmPerCount.*settings.sensorPollFreq;
analysisSettings.bins = (binSize/2)+ binSize.*(-10:210);

% Threshold for selecting trials based on forward speed 
%speedThreshold = 10;

% Rotation settings
analysisSettings.rotationSpeedThreshold = 0;
analysisSettings.blockRotation = 1;

% Number of trials to use if using same number across all experiments 
analysisSettings.defaultNumTrials = 100; 

% Number of trials to use for each prefix code (if not using all trials)
prefixCodes = {'Freq','Males','a2Glued','a3Glued','ShamGlued-45','RightGlued','LeftGlued','ShamGlued-0','Diag','Cardinal'};
valueSet = [70; 100; 100; 440; ones(6,1)*analysisSettings.defaultNumTrials];
analysisSettings.prefixCodeTrialNums = containers.Map(prefixCodes,valueSet);
clear prefixCodes valueSet

% Size of blocks for looking at adapation
analysisSettings.blockSize = 50;
