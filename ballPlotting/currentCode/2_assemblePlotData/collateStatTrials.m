function plotData = collateStatTrials(groupedData,plotData,stimNumInd,stimNum)

% Time points to assess speed before stim onset 
startInd = 176; 
endInd = 200; 

%% Select above threshold trials 
yVelMat = groupedData.rotYVel(stimNumInd,:);
xVelMat = groupedData.rotXVel(stimNumInd,:);

%% Determine in which of those trials the fly is stationary before stim onset
meanAbsVel = abs(mean(yVelMat(:,startInd:endInd)'));
belowThresholdTrials = find(meanAbsVel < 10); 

plotData.statTrialsX{stimNum} = xVelMat(belowThresholdTrials,:);  
plotData.statTrialsY{stimNum} = yVelMat(belowThresholdTrials,:);