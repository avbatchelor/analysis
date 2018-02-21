function groupedData = rotateAllTrials(groupedData)

%% Calculate rotation angle 

% Select fast trials 
trialsToInclude = 3<groupedData.trialSpeed;
allFastTrials = groupedData.trialNum(trialsToInclude);

% Get chunk of trial before stimulus start 
xDispMat = cell2mat(groupedData.xDisp); 
yDispMat = cell2mat(groupedData.yDisp);
xDispBefore = xDispMat(1:groupedData.pipStartInd-2,allFastTrials);
yDispBefore = yDispMat(1:groupedData.pipStartInd-2,allFastTrials);

% Create displacement vector 
trialVect = [mean(xDispBefore(1,:));mean(yDispBefore(1,:))];

% Create reference vector 
refVect = [0; -1];

% Calculate angle to rotate 
rotAng = acos(dot(trialVect,refVect)/(norm(trialVect)*norm(refVect)));
if trialVect(1) > 0
    R = [cos(rotAng) sin(rotAng);-sin(rotAng) cos(rotAng)];
elseif trialVect(1) <= 0
    R = [cos(rotAng) -sin(rotAng);sin(rotAng) cos(rotAng)];
end


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
    rotVel(j,:,:) = R*[groupedData.xVel{j}';groupedData.yVel{j}'];
    rotDisp(j,:,:) = R*[groupedData.xDisp{j}';groupedData.yDisp{j}'];
end

% Separate X and Y axes into different matrices 
groupedData.rotXDisp = squeeze(rotDisp(:,1,:));
groupedData.rotYDisp = squeeze(rotDisp(:,2,:));
groupedData.rotXVel = squeeze(rotVel(:,1,:));
groupedData.rotYVel = squeeze(rotVel(:,2,:));

