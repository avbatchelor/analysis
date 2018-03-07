%% Analysis Settings
% Load Ball Settings 
settings = ballSettings; 

% Set analysis settings 
dsFactor = 400;
timeBefore = 0.3;
binSize = settings.mmPerCount.*settings.sensorPollFreq;
bins = (binSize/2)+ binSize.*(-128:128);
speedThreshold = 3;
