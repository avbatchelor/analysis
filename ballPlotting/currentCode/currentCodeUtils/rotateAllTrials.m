function rotateAllTrials

%% Calculate rotation angle 

% Select fast trials 
trialsToInclude = 3<groupedData.trialSpeed;
allFastTrials = groupedData.trialNum(trialsToInclude);

% Get chunk of trial before stimulus start 
xDispAFT = [groupedData.startChunk.xDisp{allFastTrials}];
yDispAFT = [groupedData.startChunk.yDisp{allFastTrials}];

% Create displacement vector 
trialVect = [mean(xDispAFT(1,:));mean(yDispAFT(1,:))];

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

% Calculate number of trials 
trialNums = 1:length(groupedData.stimNum);

% Rotate each trial one by one 
count = 0;
for j = stimNumInd
    count = count+1;
    rotVel(count,:,:) = R*[groupedData.xVel{j}';groupedData.yVel{j}'];
    rotDisp(count,:,:) = R*[groupedData.xDisp{j}';groupedData.yDisp{j}'];
end

% Separate X and Y axes into different matrices 
rotXDisp = squeeze(rotDisp(:,1,:));
rotYDisp = squeeze(rotDisp(:,2,:));
rotXVel = squeeze(rotVel(:,1,:));
rotYVel = squeeze(rotVel(:,2,:));

