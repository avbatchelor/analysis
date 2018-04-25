%% Analysis Settings
% Load Ball Settings 
settings = ballSettings; 

% Downsample factor for downsampling velocity and displacement
dsFactor = 400;

% Downsampled sample rate
dsRate = 100; 

% For line plot, amount of time before and after stimulus to measure
% displacement
timeBefore = 0.32;
stopLatency = 0.12;
velAvgTime = 0.5;

% Bin size for forward speed histogram
binSize = settings.mmPerCount.*settings.sensorPollFreq;
bins = (binSize/2)+ binSize.*(-128:128);

% Threshold for selecting trials based on forward speed 
%speedThreshold = 10;

% Number of trials to use if using same number across all experiments 
defaultNumTrials = 100; 

% Number of trials to use for each prefix code (if not using all trials)
prefixCodes = {'Freq','Males','a2Glued','a3Glued','ShamGlued-45','RightGlued','LeftGlued','ShamGlued-0','Diag','Cardinal'};
valueSet = [70; 100; 100; 440; ones(6,1)*defaultNumTrials];
prefixCodeTrialNums = containers.Map(prefixCodes,valueSet);
clear prefixCodes valueSet

% Size of blocks for looking at adapation
blockSize = 50;
