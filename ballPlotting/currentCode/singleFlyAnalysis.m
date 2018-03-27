function singleFlyAnalysis(prefixCode,expNum,flyNum,flyExpNum)


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
analysisSettings;

%% Create save folder
fileStem = char(regexp(pPath,'.*(?=flyExpNum)','match'));
saveFolder = [fileStem,'Figures\'];
mkdir(saveFolder)
plotData.saveFolder = saveFolder;

%% Hardcoded paramters
analysisSettings;
plotData.pipStartInd = Stim.startPadDur*Stim.sampleRate/dsFactor + 1;
plotData.pipEndInd = (Stim.startPadDur+Stim.stimDur)*Stim.sampleRate/dsFactor + 1;
plotData.pipStartTime = Stim.startPadDur + 1/Stim.sampleRate;
indBefore = plotData.pipStartInd - timeBefore*Stim.sampleRate/dsFactor;
indAfter = plotData.pipStartInd + timeBefore*Stim.sampleRate/dsFactor;

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
        stimIndSamp = randInd(1:10);
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
    
    %% Find the mean and std of these trials
    plotData.meanXDisp(stimNum,:)   = mean(groupedData.rotXDisp(stimNumInd,:));
    plotData.meanYDisp(stimNum,:)   = mean(groupedData.rotYDisp(stimNumInd,:));
    plotData.meanXVel(stimNum,:)    = mean(groupedData.rotXVel(stimNumInd,:));
    plotData.meanYVel(stimNum,:)    = mean(groupedData.rotYVel(stimNumInd,:));
    
    plotData.stdXDisp(stimNum,:)    = std(groupedData.rotXDisp(stimNumInd,:));
    plotData.stdYDisp(stimNum,:)    = std(groupedData.rotYDisp(stimNumInd,:));
    plotData.stdXVel(stimNum,:)     = std(groupedData.rotXVel(stimNumInd,:));
    plotData.stdYVel(stimNum,:)     = std(groupedData.rotYVel(stimNumInd,:));
    
    
    %% Data for plot stimulus
    plotData.stimTimeVector(stimNum,:) = StimStruct(stimNum).stimObj.timeVec(1,1:minStimLength);
    plotData.stimulus(stimNum,:) = StimStruct(stimNum).stimObj.stimulus(1:minStimLength);
    
    plotData.pipEndTime(stimNum) = (StimStruct(stimNum).stimObj.startPadDur+StimStruct(stimNum).stimObj.stimDur) + 1/StimStruct(stimNum).stimObj.sampleRate;
    
    %% Downsampled time
    plotData.dsTime(stimNum,:) = groupedData.dsTime{stimNum};
    
    
    %% Sample trials
    plotData.sampleTrialsDisp{stimNum}   = [groupedData.rotXDisp(stimIndSamp,:),groupedData.rotYDisp(stimIndSamp,:)];
    plotData.sampleTrialsVel{stimNum}    = [groupedData.rotXVel(stimIndSamp,:),groupedData.rotYVel(stimIndSamp,:)];
    
    
    %% Data for plot forward speed histogram
    plotData.velForHistogram = groupedData.rotYVel(:);
    
    
    %% Data for plot avg. trial speed
    % Plot all trials in gray
    plotData.trialSpeed = groupedData.trialSpeed;
    
    %% Data for displacement histogram
    % Trials x axis x timepoint
    plotData.xDispLinePlot{stimNum} = groupedData.rotXDisp(stimNumInd,[indBefore,plotData.pipStartInd,indAfter]);
    plotData.yDispLinePlot{stimNum} = groupedData.rotYDisp(stimNumInd,[indBefore,plotData.pipStartInd,indAfter]);
    
    
    %% Figure filename
    plotData.saveFileName{stimNum} = [saveFolder,'flyExpNum',num2str(exptInfo.flyExpNum,'%03d'),'\','flyExpNum',num2str(exptInfo.flyExpNum,'%03d'),'_fig1','_stim',num2str(stimNum,'%03d'),'.pdf'];
    
    
end

%% Save Plot data to file
% Grouped data
fileName = [pPath,fileNamePreamble,'plotData.mat'];
save(fileName,'plotData')