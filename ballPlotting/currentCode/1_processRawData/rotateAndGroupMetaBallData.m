function rotateAndGroupMetaBallData(prefixCode,expNum,flyNum,flyExpNum)

%% Put exptInfo in a struct
exptInfo = exptInfoStruct(prefixCode,expNum,flyNum,flyExpNum);

%% Load analysis settings 
analysisSettings = getAnalysisSettings;

%% Load processed data
% Get paths
[~, ~, fileNamePreamble, ~] = getDataFileNameBall(exptInfo);
pPath = getProcessedDataFileName(exptInfo);

% Grouped data
try 
    fileName = [pPath,fileNamePreamble,'processedAndDownsampledData.mat'];
    load(fileName);
catch
    disp('Loading old grouped data file')
    fileName = [pPath,fileNamePreamble,'groupedData.mat'];
    load(fileName)
    clear StimStruct 
    groupedData = rmfield(groupedData,{'stimNum','trialNum','pipStartInd','trialSpeed','rotXDisp','rotYDisp','rotXVel','rotYVel'});
end
    
%% Load raw data
[~, path, fileNamePreamble, ~] = getDataFileNameBall(exptInfo);
cd(path);
dirCont = dir('*trial*');

% Load exptInfo
load(fullfile(path,[fileNamePreamble,'exptData']))

%% Loop through trials, process and save 
groupedData.stimNum = [];

for i = 1:length(dirCont)
    
    %% Load data 
    load(fullfile(path,dirCont(i).name));
    
    %% Get trial and stim num
    trialNum = trialMeta.trialNum;
    stimNum = trialMeta.stimNum;

    %% Make stim struct 
    if any(groupedData.stimNum == stimNum)
    else
        StimStruct(stimNum).stimObj = Stim;
    end

    %% Meta data 
    groupedData.stimNum(trialNum) = trialMeta.stimNum;
    groupedData.trialNum(trialNum) = trialMeta.trialNum;  
    groupedData.pipStartInd = Stim.startPadDur*Stim.sampleRate/analysisSettings.dsFactor + 1;    
    
    %% Calculate mean resultant speed for each trial
    groupedData.trialSpeed(trialNum) = mean(sqrt((groupedData.xVel{trialNum}.^2)+(groupedData.yVel{trialNum}.^2)));
    
    %% Clear trial data 
    clear procData temp
end

%% Rotate data 
groupedData = rotateAllTrials(groupedData);

%% Save data
pPath = getProcessedDataFileName(exptInfo);
mkdir(pPath);
fileName = [pPath,fileNamePreamble,'groupedData.mat'];
save(fileName, 'groupedData','StimStruct');

