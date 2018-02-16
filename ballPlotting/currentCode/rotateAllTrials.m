function rotateAllTrials

refVect = [0; -1];
if sum(trialsToInclude) == 0
    return
end
trialNums = 1:length(groupedData.stimNum);
allFastTrials = trialNums(trialsToInclude);
xDispAFT = [groupedData.startChunk.xDisp{allFastTrials}];
yDispAFT = [groupedData.startChunk.yDisp{allFastTrials}];
trialVect = [mean(xDispAFT(1,:));mean(yDispAFT(1,:))];
rotAng = acos(dot(trialVect,refVect)/(norm(trialVect)*norm(refVect)));
if trialVect(1) > 0
    R = [cos(rotAng) sin(rotAng);-sin(rotAng) cos(rotAng)];
elseif trialVect(1) <= 0
    R = [cos(rotAng) -sin(rotAng);sin(rotAng) cos(rotAng)];
end

%% Rotate each of these trials
count = 0;
for j = stimNumInd
    count = count+1;
    rotVel(count,:,:) = R*[groupedData.xVel{j}';groupedData.yVel{j}'];
    rotDisp(count,:,:) = R*[groupedData.xDisp{j}';groupedData.yDisp{j}'];
end

if isempty(stimNumInd)
    disp('no trials fast enough for this stim')
    continue
en

rotXDisp = squeeze(rotDisp(:,1,:));
rotYDisp = squeeze(rotDisp(:,2,:));
rotXVel = squeeze(rotVel(:,1,:));
rotYVel = squeeze(rotVel(:,2,:));

if length(stimNumInd) == 1
    rotXDisp = rotXDisp';
    rotYDisp = rotYDisp';
    rotXVel = rotXVel';
    rotYVel = rotYVel';
end