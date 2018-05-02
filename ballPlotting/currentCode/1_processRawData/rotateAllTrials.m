function groupedData = rotateAllTrials(groupedData)

%% Load settings
analysisSettings = getAnalysisSettings;

%% Prepare data
% Convert displacement cells to matrices
xDispMat = cell2mat(groupedData.xDisp);
yDispMat = cell2mat(groupedData.yDisp);

% Select part of displacement vector
xDispBefore = xDispMat(1:groupedData.pipStartInd-2,:);
yDispBefore = yDispMat(1:groupedData.pipStartInd-2,:);

%% Average rotation
% Select fast trials
trialsToInclude = analysisSettings.rotationSpeedThreshold<groupedData.trialSpeed;
allFastTrials = groupedData.trialNum(trialsToInclude);

% Create displacement vector
xDispBeforeFastTrials = xDispBefore(:,allFastTrials);
yDispBeforeFastTrials = yDispBefore(:,allFastTrials);
trialVect = [mean(mean(xDispBeforeFastTrials,2));mean(mean(yDispBeforeFastTrials,2))];

% Calculate rotation angle to use if not rotating in blocks 
Ravg = getRotationAngle(trialVect);

%% Prepare data for block rotation
% Generate moving average of displacement vectors 
xDispMovMean = mean(movmean(xDispBefore,analysisSettings.blockSize,2));
yDispMovMean = mean(movmean(yDispBefore,analysisSettings.blockSize,2));

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
        R = getRotationAngle(blockTrialVect);
        if any(isnan(R))
            R = Ravg;
        end
    end
    
    rotVel = R*[groupedData.xVel{j}';groupedData.yVel{j}'];
    rotDisp = R*[groupedData.xDisp{j}';groupedData.yDisp{j}'];
    
    % Separate X and Y axes into different matrices
    groupedData.rotXDisp(j,:) = squeeze(rotDisp(1,:));
    groupedData.rotYDisp(j,:) = squeeze(rotDisp(2,:));
    groupedData.rotXVel(j,:) = squeeze(rotVel(1,:));
    groupedData.rotYVel(j,:) = squeeze(rotVel(2,:));
    
    if any(isnan(rotVel))
        error('nan problem')
    end
    
end

end

function R = getRotationAngle(trialVect)

% Create reference vector
refVect = [0; -1];

% Calculate angle to rotate
rotAng = acos(dot(trialVect,refVect)/(norm(trialVect)*norm(refVect)));
if trialVect(1) > 0
    R = [cos(rotAng) sin(rotAng);-sin(rotAng) cos(rotAng)];
elseif trialVect(1) <= 0
    R = [cos(rotAng) -sin(rotAng);sin(rotAng) cos(rotAng)];
end

end