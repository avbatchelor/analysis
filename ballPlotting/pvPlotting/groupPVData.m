function groupPVData(prefixCode,expNum,flyNum,flyExpNum)

%% Allocate expt Info 
exptInfo.prefixCode     = prefixCode;
exptInfo.expNum         = expNum;
exptInfo.flyNum         = flyNum;
exptInfo.flyExpNum      = flyExpNum;

%% Find trial files 
[~, path, fileNamePreamble, ~] = getDataFileNameBall(exptInfo);
cd(path);
dirCont = dir('*trial*');
numTrials = length(dirCont);

%% Make empty stim sequence vector
stimSequence = [];


%% Get data from each trial 
for i = 1:numTrials
    % Load data 
    load(dirCont(i).name);
    settings = ballSettingsWithPV;
    
    % Get trial and stim num 
    trialNum = trialMeta.trialNum;
    stimNum = trialMeta.stimNum;
    
    % Group data 
    groupedData.stim{trialMeta.stimNum} = Stim.stimulus;
    groupedData.stimStartInd{trialMeta.stimNum} = Stim.startPadDur*Stim.sampleRate;
    groupedData.stimEndInd{trialMeta.stimNum} = (Stim.startPadDur+Stim.stimDur)*Stim.sampleRate;
    groupedData.stimTimeVect{trialMeta.stimNum} = Stim.timeVec;
    groupedData.stimNum(trialNum) = trialMeta.stimNum;
    groupedData.stimStartPadDur{trialMeta.stimNum} = Stim.startPadDur;
    groupedData.stimDur{trialMeta.stimNum} = Stim.stimDur;
    groupedData.pv{trialNum} = data.pv;
    groupedData.acqStim1{trialNum} = data.acqStim1;
    if isfield(groupedData,'acqStim2')
        groupedData.acqStim2{trialNum} = data.acqStim2;
    end
    groupedData.KEraw{trialNum} = data.KEraw;
    if isfield(Stim,'description')
        groupedData.description{trialMeta.stimNum} = Stim.description;
    else
        groupedData.description{trialMeta.stimNum} = 'no stim description';
    end
    
    %% Get stimulus info
    if any(stimSequence == stimNum)
    else
        StimStruct(stimNum).stimObj = Stim;
    end
    
    % Record stim num sequenceata matrix
    stimSequence = [stimSequence, stimNum];
    
end

fileName = [path,fileNamePreamble,'groupedData.mat'];
save(fileName, 'groupedData','StimStruct','-v7.3');


