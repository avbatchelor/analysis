function groupedData = selectTrials(groupedData,exptInfo)

%% Load analysis settings 
analysisSettings = getAnalysisSettings; 

%% Select trials based on speed 
xVelMat = cell2mat(groupedData.xVel);
yVelMat = cell2mat(groupedData.yVel);

startInd = 1;
endInd = groupedData.pipStartInd - 1; 

preStimSpeed = mean( sqrt( ( xVelMat(startInd:endInd,:) .^2 ) + ( yVelMat(startInd:endInd,:) .^2 ) ) );

trialsToInclude = find(preStimSpeed > analysisSettings.speedThreshold);

groupedData.fastEnoughTrials = trialsToInclude; 

%% Remove saturated trials 
[xExclude,~,~,yExclude,~,~] = findSatIdxs(exptInfo,xVelMat,yVelMat);
trialsToExclude = unique([xExclude,yExclude]);

groupedData.saturatedTrials = trialsToExclude;

%% Selected trials 
groupedData.selectedTrials = setdiff(trialsToInclude,trialsToExclude);
