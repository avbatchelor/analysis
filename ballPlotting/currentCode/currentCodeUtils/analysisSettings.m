%% Analysis Settings
% Load Ball Settings 
ballSettings; 

% Set analysis settings 
dsFactor = 400;
timeBefore = 0.3;
binSize = settings.mmPerCount.*settings.sensorPollFreq;
bins = (binSize/2)+(binSize*-255:255);
speedThreshold = 3;
