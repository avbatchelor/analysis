function checkAvgSpeed(exptInfo, xVel, yVel)

% Get paths
[~,~, fileNamePreamble, ~] = getDataFileNameBall(exptInfo);
pPath = getProcessedDataFileName(exptInfo);

% Load grouped data
fileName = [pPath,fileNamePreamble,'groupedData.mat'];
load(fileName);

% Set pre-stim time points 
startInd = 1;
endInd = groupedData.pipStartInd - 1; 

% Calclulate pre-stim speed 
preStimSpeed = mean( sqrt( ( xVel(:,startInd:endInd) .^2 ) + ( yVel(:,startInd:endInd) .^2 ) ) );

% Print out speed 
disp(preStimSpeed)