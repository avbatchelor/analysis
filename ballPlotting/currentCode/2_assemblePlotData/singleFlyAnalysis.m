function singleFlyAnalysis(prefixCode,expNum,flyNum,flyExpNum,speedThreshold)


%% Put exptInfo in a struct
exptInfo = exptInfoStruct(prefixCode,expNum,flyNum,flyExpNum);

%% Load data
% Get paths
[~, path, fileNamePreamble, ~] = getDataFileNameBall(exptInfo);
pPath = getProcessedDataFileName(exptInfo);

% Grouped data
fileName = [pPath,fileNamePreamble,'groupedData.mat'];
load(fileName);

% Expt data
fileName = [path,fileNamePreamble,'exptData.mat'];
load(fileName);

% First trial
firstTrialFileName = [path,fileNamePreamble,'trial',num2str(1,'%03d'),'.mat'];
load(firstTrialFileName);

% Fly data
flyDataPath = char(regexp(path,'.*(?=flyExpNum)','match'));
flyDataPreamble = char(regexp(fileNamePreamble,'.*(?=flyExpNum)','match'));
flyDataFileName = [flyDataPath,flyDataPreamble,'flyData'];
load(flyDataFileName);

% Analysis settings
analysisSettings = getAnalysisSettings;

%% Create save folder
fileStem = char(regexp(pPath,'.*(?=flyExpNum)','match'));
saveFolder = fileStem;
mkdir(saveFolder)
mkdir([saveFolder,'basic\'])
plotData.saveFolder = saveFolder;

%% Hardcoded paramters
analysisSettings;
plotData.pipStartInd = Stim.startPadDur*Stim.sampleRate/analysisSettings.dsFactor + 1;
plotData.pipEndInd = (Stim.startPadDur+Stim.stimDur)*Stim.sampleRate/analysisSettings.dsFactor + 1;
plotData.pipStartTime = Stim.startPadDur + 1/Stim.sampleRate;
indBefore = plotData.pipStartInd - analysisSettings.timeBefore*Stim.sampleRate/analysisSettings.dsFactor;
indAfter = plotData.pipStartInd + analysisSettings.timeBefore*Stim.sampleRate/analysisSettings.dsFactor;

%% Select trials based on speed
trialsToInclude = speedThreshold<groupedData.trialSpeed;
trialsToIncludeIdxs = groupedData.trialNum(trialsToInclude);
plotData.fastTrials = trialsToIncludeIdxs;

%% Calculate number of stimuli and stim types
% Number of unique stimuli - same stimulus at different location considered
% unique stimulus
uniqueStim = unique(groupedData.stimNum);
plotData.numUniqueStim = length(uniqueStim);

% Number of stim types - stimuli are considered the same 'type' if the
% sound played by the speaker is identical
stimType = sameStim(StimStruct);

%% Number of trials
plotData.numTrials = groupedData.trialNum(end);

%% Assign figure numbers
plotData.figureNums.allDiffFigs = uniqueStim;
plotData.figureNums.allSameFig = ones(size(uniqueStim));
plotData.figureNums.figByType = unique(stimType);


%% Data for title
dateAsString = datestr(datenum(exptInfo.dNum,'yymmdd'),'mm-dd-yy');
plotData.sumTitle = {[dateAsString,', ',exptInfo.prefixCode,', ExpNum ',num2str(exptInfo.expNum),', FlyNum ',num2str(exptInfo.flyNum),...
    ', FlyExpNum ',num2str(exptInfo.flyExpNum)];['Aim: ',char(FlyData.aim),', Description: ',StimStruct(1).stimObj.description];...
    ['X Saturation Count = ',num2str(sum(groupedData.xSaturationWarning)),', Y Saturation Count = ',num2str(sum(groupedData.ySaturationWarning))]};

%% Create empty matrices
plotData.legendText = cell(size(uniqueStim));
stimCount = 0;

%% Work out length of shortest stimulus 
stimLength = size(uniqueStim);
for stimNum = uniqueStim
    stimLength(stimNum) = length(StimStruct(stimNum).stimObj.timeVec);
end
minStimLength = min(stimLength);

%% Sort trials by previous trial
% Find stimuli with speaker at 45 deg 
rightIdxs = find(groupedData.stimNum == 2);

% Find stimuli that are 1 trial after these stimuli
oneAfter = rightIdxs + 1; 

% Find stimuli that are 2 trials after these stimuli (and not one trial
% after)
twoAfter = setdiff(rightIdxs + 2,oneAfter);

% Find stimuli that are 3 trials after these stimuli (and not one or two
% trials after)
oneAndTwoAfter = union(oneAfter,twoAfter);
threeAfter = setdiff(rightIdxs + 3, oneAndTwoAfter);

stimOrder{1} = oneAfter; 
stimOrder{2} = twoAfter; 
stimOrder{3} = threeAfter;

groupedData.xSaturationWarning(groupedData.trialNum);


%% Loop through each stimulus
for stimNum = uniqueStim
    
    stimCount = stimCount + 1;
    
    %% Find the indexes for trials belonging to this stimulus
    % Find trials belonging to that stimulus
    stimSelect = find(groupedData.stimNum == uniqueStim(stimNum));
    
    % Select the trials that belonging to the stimulus that are fast
    % enough
    stimNumInd = intersect(trialsToIncludeIdxs,stimSelect);
    plotData.trialsSelectedByStimAndSpeed{stimNum} = stimNumInd;
    
    % Randomly select 10 trials for plotting individual trials
    randInd = randperm(length(stimNumInd));
    try
        stimIndSamp = stimNumInd(randInd(1:10));
    catch
        stimIndSamp = [];
    end
    
    % Calculate number of good trials for that stimulus
    plotData.numGoodTrials(stimNum) = length(stimNumInd);
    plotData.numAllTrials(stimNum) = length(stimSelect);
    
    
    %% Set legend text
    if isfield(StimStruct(stimNum).stimObj,'speakerAngle')
        plotData.legendText{stimNum} = ['Angle = ',num2str(StimStruct(stimNum).stimObj.speakerAngle),', ',num2str(StimStruct(stimNum).stimObj.description)];
    else
        plotData.legendText{stimNum} = '';
    end
    
    %% Find the mean, median and std of these trials
    plotData.meanXDisp(stimNum,:)   = mean(groupedData.rotXDisp(stimNumInd,:));
    plotData.meanYDisp(stimNum,:)   = mean(groupedData.rotYDisp(stimNumInd,:));
    plotData.meanXVel(stimNum,:)    = mean(groupedData.rotXVel(stimNumInd,:));
    plotData.meanYVel(stimNum,:)    = mean(groupedData.rotYVel(stimNumInd,:));
    
    plotData.medianXDisp(stimNum,:)   = median(groupedData.rotXDisp(stimNumInd,:));
    plotData.medianYDisp(stimNum,:)   = median(groupedData.rotYDisp(stimNumInd,:));
    plotData.medianXVel(stimNum,:)    = median(groupedData.rotXVel(stimNumInd,:));
    plotData.medianYVel(stimNum,:)    = median(groupedData.rotYVel(stimNumInd,:));
    
    plotData.stdXDisp(stimNum,:)    = std(groupedData.rotXDisp(stimNumInd,:));
    plotData.stdYDisp(stimNum,:)    = std(groupedData.rotYDisp(stimNumInd,:));
    plotData.stdXVel(stimNum,:)     = std(groupedData.rotXVel(stimNumInd,:));
    plotData.stdYVel(stimNum,:)     = std(groupedData.rotYVel(stimNumInd,:));
    
    %% Find the block means  (i.e. the mean for each stimulus for every 100 trials or so) 
    % Number of blocks = minimum number of trials for each stimulus /
    % analysisSettings.blockSize, rounded down to nearest integer
    trialsPerStim = histc(groupedData.stimNum(trialsToIncludeIdxs),uniqueStim);
    minNumTrialsAllStim = min(trialsPerStim);
    numBlocks = floor(minNumTrialsAllStim/analysisSettings.blockSize);
    for i = 1:numBlocks
        blockStart = (i-1)*analysisSettings.blockSize + 1;
        blockEnd = i*analysisSettings.blockSize;
        plotData.blockMeanXDisp(stimNum,i,:) = mean(groupedData.rotXDisp(stimNumInd(blockStart:blockEnd),:));
        plotData.blockMeanYDisp(stimNum,i,:) = mean(groupedData.rotYDisp(stimNumInd(blockStart:blockEnd),:));
        plotData.blockMeanXVel(stimNum,i,:) = mean(groupedData.rotXVel(stimNumInd(blockStart:blockEnd),:));
        plotData.blockMeanYVel(stimNum,i,:) = mean(groupedData.rotYVel(stimNumInd(blockStart:blockEnd),:));
    end
    
    %% Find means by stim order 
    for i = 1:3
        stimOrderSelection = intersect(stimNumInd,stimOrder{i});
        plotData.stimOrderMeanXDisp(stimNum,i,:) = mean(groupedData.rotXDisp(stimOrderSelection,:));
        plotData.stimOrderMeanYDisp(stimNum,i,:) = mean(groupedData.rotYDisp(stimOrderSelection,:));
        plotData.stimOrderMeanXVel(stimNum,i,:) = mean(groupedData.rotXVel(stimOrderSelection,:));
        plotData.stimOrderMeanYVel(stimNum,i,:) = mean(groupedData.rotYVel(stimOrderSelection,:));
    end
    
    %% Data for plot stimulus
    plotData.stimTimeVector(stimNum,:) = StimStruct(stimNum).stimObj.timeVec(1,1:minStimLength);
    plotData.stimulus(stimNum,:) = StimStruct(stimNum).stimObj.stimulus(1:minStimLength);
    
    plotData.pipEndTime(stimNum) = (StimStruct(stimNum).stimObj.startPadDur+StimStruct(stimNum).stimObj.stimDur) + 1/StimStruct(stimNum).stimObj.sampleRate;
    
    %% Downsampled time
    plotData.dsTime(stimNum,:) = groupedData.dsTime{stimNum};
    
    
    %% Sample trials
    plotData.sampleTrialsXDisp{stimNum} = groupedData.rotXDisp(stimIndSamp,:);
    plotData.sampleTrialsYDisp{stimNum} = groupedData.rotYDisp(stimIndSamp,:);
    plotData.sampleTrialsXVel{stimNum}  = groupedData.rotXVel(stimIndSamp,:);
    plotData.sampleTrialsYVel{stimNum}  = groupedData.rotYVel(stimIndSamp,:);
    
    %% Data for plot forward speed histogram
    plotData.velForHistogram = groupedData.rotYVel(:);
    
    
    %% Data for plot avg. trial speed
    % Plot all trials in gray
    plotData.trialSpeed = groupedData.trialSpeed;
    
    %% Data for displacement histogram
    % Trials x axis x timepoint
    plotData.xDispLinePlot{stimNum} = groupedData.rotXDisp(stimNumInd,[indBefore,plotData.pipStartInd,indAfter]);
    plotData.yDispLinePlot{stimNum} = groupedData.rotYDisp(stimNumInd,[indBefore,plotData.pipStartInd,indAfter]);
    
    %% Data for scatter plot
    plotData.preStimSpeed{stimNum} = mean(groupedData.rotYVel(stimNumInd,plotData.pipStartInd - (analysisSettings.velAvgTime*analysisSettings.dsRate):plotData.pipStartInd),2);
    plotData.latDisp{stimNum} = groupedData.rotXDisp(stimNumInd,indAfter);
    plotData.stopSpeed{stimNum} = groupedData.rotYVel(stimNumInd,plotData.pipStartInd+(analysisSettings.stopLatency*analysisSettings.dsRate));
    plotData.trialSpeedForScatter{stimNum} = plotData.trialSpeed(stimNumInd);
    plotData.trialNumForScatter{stimNum} = groupedData.trialNum(stimNumInd);
    
    %% Figure filename
    plotData.saveFileName{stimNum} = [saveFolder,'basic\','flyExpNum',num2str(exptInfo.flyExpNum,'%03d'),'_fig1','_stim',num2str(stimNum,'%03d'),'.pdf'];
    
    
end

%% Save Plot data to file
% Grouped data
fileName = [pPath,fileNamePreamble,'plotData.mat'];
save(fileName,'plotData')