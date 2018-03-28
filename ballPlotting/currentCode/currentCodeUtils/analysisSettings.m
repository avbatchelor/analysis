%% Analysis Settings
% Load Ball Settings 
settings = ballSettings; 

% Set analysis settings 
dsFactor = 400;
timeBefore = 0.3;
binSize = settings.mmPerCount.*settings.sensorPollFreq;
bins = (binSize/2)+ binSize.*(-128:128);
speedThreshold = 3;

% 
threshold = 10;
defaultNumTrials = 100; 
prefixCodes = {'Freq','Males','a2Glued','a3Glued','ShamGlued-45','RightGlued','LeftGlued','ShamGlued-0','Diag','Cardinal'};
valueSet = [70; ones(length(prefixCodes)-1,1)*defaultNumTrials];
prefixCodeTrialNums = containers.Map(prefixCodes,valueSet);
clear prefixCodes valueSet
