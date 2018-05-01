function groupedData = rotateAllTrials(groupedData)

%% Load settings
analysisSettings = getAnalysisSettings;

%% Calculate rotation angle
% Select fast trials
% trialsToInclude = analysisSettings.rotationSpeedThreshold<groupedData.trialSpeed;
% allFastTrials = groupedData.trialNum(trialsToInclude);

% Convert displacement cells to matrices
xDispMat = cell2mat(groupedData.xDisp);
yDispMat = cell2mat(groupedData.yDisp);

% Select part of displacement vector
xDispBefore = xDispMat(1:groupedData.pipStartInd-2,:);
yDispBefore = yDispMat(1:groupedData.pipStartInd-2,:);

% Create displacement vector
% trialVect = [mean(xDispBefore(1,:));mean(yDispBefore(1,:))];
trialVect = [mean(mean(xDispBefore,2));mean(mean(yDispBefore,2))];

% Create reference vector
refVect = [0; -1];

% Calculate rotation angle to use if not rotating in blocks 
Ravg = getRotationAngle(trialVect,refVect);

% Generate moving average of displacement vectors 
xDispMovMean = mean(movmean(xDispBefore,analysisSettings.blockSize));
yDispMovMean = mean(movmean(yDispBefore,analysisSettings.blockSize));

%% Rotate each trial
% Preallocate matrices
numTrials = length(groupedData.trialNum);
trialLength = size(xDispMat,1);
rotVel = NaN(numTrials,2,trialLength);
rotDisp = NaN(numTrials,2,trialLength);
groupedData.rotXDisp = NaN(numTrials,trialLength);
groupedData.rotYDisp = NaN(numTrials,trialLength);
groupedData.rotXVel = NaN(numTrials,trialLength);
groupedData.rotYVel = NaN(numTrials,trialLength);

% Rotate each trial one by one
for j = groupedData.trialNum
    if analysisSettings.blockRotation == 0
        R = Ravg;
    else
        blockTrialVect = [xDispMovMean(j),yDispMovMean(j)];
        R = getRotationAngle(blockTrialVect,refVect);
    end
    
    rotVel(j,:,:) = R*[groupedData.xVel{j}';groupedData.yVel{j}'];
    rotDisp(j,:,:) = R*[groupedData.xDisp{j}';groupedData.yDisp{j}'];
    
    % Separate X and Y axes into different matrices
    groupedData.rotXDisp = squeeze(rotDisp(:,1,:));
    groupedData.rotYDisp = squeeze(rotDisp(:,2,:));
    groupedData.rotXVel = squeeze(rotVel(:,1,:));
    groupedData.rotYVel = squeeze(rotVel(:,2,:));
    
end

end

function R = getRotationAngle(trialVect,refVect)

% Calculate angle to rotate
rotAng = acos(dot(trialVect,refVect)/(norm(trialVect)*norm(refVect)));
if trialVect(1) > 0
    R = [cos(rotAng) sin(rotAng);-sin(rotAng) cos(rotAng)];
elseif trialVect(1) <= 0
    R = [cos(rotAng) -sin(rotAng);sin(rotAng) cos(rotAng)];
end

end