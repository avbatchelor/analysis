function [xMid,xFirst,xOne,yMid,yFirst,yOne,timePts] = findSatIdxs(exptInfo,xVel,yVel)

%% Get experiment date
[~, path, fileNamePreamble, ~] = getDataFileNameBall(exptInfo);

% Load exptInfo
load(fullfile(path,[fileNamePreamble,'exptData']))

%% Find saturated time points
settings = ballSettings; 

% X saturation value 
xSatVals = [-127 127] .* (settings.mmPerCount * settings.sensorPollFreq);

% Y saturation value 
if datenum(exptInfo.dNum,'yymmdd') < datenum('180206','yymmdd')
    ySatVals = xSatVals; 
else
    ySatVals(1) = -50 * (settings.mmPerCount * settings.sensorPollFreq);
    ySatVals(2) = 204 * (settings.mmPerCount * settings.sensorPollFreq);
end 

% Find saturated time points
xSatTimePts = (abs(xVel - xSatVals(1)) < 0.1) | (abs(xVel - xSatVals(2)) < 0.1);
ySatTimePts = (abs(yVel - ySatVals(1)) < 0.1) | (abs(yVel - ySatVals(2)) < 0.1);

%% Get idxs of saturated trials
% Find trials where only x is saturated 
xFirst = findFirstSampleOnlyTrials(xVel,xSatTimePts);
xMid = find(sum(xSatTimePts) > 1);
xOne = setdiff(find(sum(xSatTimePts) == 1),xFirst);

% Find trials where only y is saturated 
yFirst = findFirstSampleOnlyTrials(yVel,ySatTimePts);
yMid = find(sum(ySatTimePts) > 1);
yOne = setdiff(find(sum(ySatTimePts) == 1),yFirst);

timePts.xSatTimePts = xSatTimePts; 
timePts.ySatTimePts = ySatTimePts;


end

function idxs = findFirstSampleOnlyTrials(vel,satTimePts)

% Find which trials only have the first sample saturated
test_row = zeros(size(vel(:,1)))';
test_row(1) = 1;
idxs = find(ismember(satTimePts',test_row,'rows'));

end

function idxs = findOneSaturatedSamplesOnlyTrials(satTimePts)

% Find which trials only have the first sample saturated
idxs = find(sum(satTimePts)>1);

end