function labelSaturatedTimePoints(prefixCode,expNum,flyNum,flyExpNum)

close all

%% Put exptInfo in a struct
exptInfo = exptInfoStruct(prefixCode,expNum,flyNum,flyExpNum);

%% Load plot data
% Get paths
[~, ~, fileNamePreamble, ~] = getDataFileNameBall(exptInfo);
pPath = getProcessedDataFileName(exptInfo);

% Plot data
fileName = [pPath,fileNamePreamble,'plotData.mat'];
load(fileName);

% Grouped data
fileName = [pPath,fileNamePreamble,'groupedData.mat'];
load(fileName);

%% Get experiment date
[~, path, fileNamePreamble, ~] = getDataFileNameBall(exptInfo);

% Load exptInfo
load(fullfile(path,[fileNamePreamble,'exptData']))


%% Get number of trials
numTrials = plotData.numTrials;
briefTitle = plotData.sumTitle{1};

%% Convert cells to matrices 
xVel = cell2mat(groupedData.xVel);
yVel = cell2mat(groupedData.yVel);

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
xSatTrials = find(sum(xSatTimePts) > 0);
xFirstSatTrials = findFirstSampleOnlyTrials(xVel,xSatTimePts);
xMidSatTrials = setdiff(xSatTrials,xFirstSatTrials);

% Find trials where only y is saturated 
ySatTrials = find(sum(ySatTimePts) > 0);
yFirstSatTrials = findFirstSampleOnlyTrials(yVel,ySatTimePts);
yMidSatTrials = setdiff(ySatTrials,yFirstSatTrials);

% Find trials where both x and y are saturated 
bothSatTrials = intersect(xMidSatTrials,yMidSatTrials);
xMidSatTrials = setdiff(xMidSatTrials,bothSatTrials);
yMidSatTrials = setdiff(yMidSatTrials,bothSatTrials); 

%% Make figure 
goFigure(70);
satSubPlot(1,xMidSatTrials,xSatTimePts,xVel,groupedData,numTrials,'X','mid',briefTitle)
satSubPlot(3,xFirstSatTrials,xSatTimePts,xVel,groupedData,numTrials,'X','first',briefTitle)
satSubPlot(2,yMidSatTrials,ySatTimePts,yVel,groupedData,numTrials,'Y','mid',briefTitle)
satSubPlot(4,yFirstSatTrials,ySatTimePts,yVel,groupedData,numTrials,'Y','first',briefTitle)
satSubPlot(5,bothSatTrials,xSatTimePts,xVel,groupedData,numTrials,'X','both',briefTitle)
satSubPlot(6,bothSatTrials,ySatTimePts,yVel,groupedData,numTrials,'Y','both',briefTitle)

%% Save figure 
folder = [plotData.saveFolder,'\saturation\'];
mkdir(folder)
[~, ~, fileNamePreamble, ~] = getDataFileNameBall(exptInfo);
filename = [folder,fileNamePreamble,'saturation_plot.pdf'];
export_fig(filename,'-pdf','-painters')
            
end

function satSubPlot(subplotNum,satTrials,satTimePts,vel,groupedData,numTrials,axis,section,briefTitle)

%% Don't plot if there are no saturated trials 
if isempty(satTrials) 
    return 
end

%% Select 10 random trials 
numSamples = min([10,length(satTrials)]);
sampleIdxs = randsample(satTrials,numSamples);

% Subplot
subplot(3,2,subplotNum)
hold on

% Plot traces
plot(groupedData.dsTime{1},vel(:,sampleIdxs))

% Plot saturated sections 
for i = 1:length(sampleIdxs)
    timePtsToPlot = satTimePts(:,sampleIdxs(i));
    plot(groupedData.dsTime{1}(timePtsToPlot),vel(timePtsToPlot,sampleIdxs(i)),'r.')
end

% Figure title 
satDescrip = sprintf('Showing %d out of %d %s saturated trials. ',numSamples,length(satTrials),section);
exptDescrip = sprintf('Total Trials = %d',numTrials);
title({[axis,' ',section];satDescrip})

% Figure settings 
if subplotNum == 5 || subplotNum == 6
    xlabel('Time (s)')
end
ylabel('Vel (mm/s)')
bottomAxisSettings
xlim([-0.1,4.5])

if strcmp(axis,'X')
    ylim([-42 42])
elseif strcmp(axis,'Y')
    ylim([-20 65])
end

suptitle({briefTitle;exptDescrip})

end

function idxs = findFirstSampleOnlyTrials(vel,satTimePts)

% Find which trials only have the first sample saturated
test_row = zeros(size(vel(:,1)))';
test_row(1) = 1;
idxs = find(ismember(satTimePts',test_row,'rows'));

end