function groupBallDataDiffStim(prefixCode,expNum,flyNum,flyExpNum)

%% Downsample paramters 
dsFactor = 400;
dsPhaseShift = 0;

%% Make exptInfo struct 
exptInfo = exptInfoStruct(prefixCode,expNum,flyNum,flyExpNum);

%% Get data filenames
[~, path, fileNamePreamble, ~] = getDataFileNameBall(exptInfo);
cd(path);
dirCont = dir('*trial*');

% Load exptInfo
load(fullfile(path,[fileNamePreamble,'exptData']))

%% Loop through trials, process and save 
groupedData.stimNum = [];

for i = 1:length(dirCont)
    
    %% Display trial number
    disp(['Trial = ',num2str(i)]);
    
    %% Load data 
    load(dirCont(i).name);
    
    %% Get trial and stim num
    trialNum = trialMeta.trialNum;
    stimNum = trialMeta.stimNum;
    
    %% Process data 
    [procData.vel(:,1),procData.disp(:,1)] = processDigBallData(data.xVelDig,Stim,'x',exptInfo);
    [procData.vel(:,2),procData.disp(:,2)] = processDigBallData(data.yVelDig,Stim,'y',exptInfo);
    
    %% Downsample velocity, displacement & time data 
    % Velocity
    groupedData.xVel{trialNum} = downsample(procData.vel(:,1),dsFactor,dsPhaseShift);
    groupedData.yVel{trialNum} = downsample(procData.vel(:,2),dsFactor,dsPhaseShift);
    
    % Displacement
    groupedData.xDisp{trialNum} = downsample(procData.disp(:,1),dsFactor,dsPhaseShift);
    groupedData.yDisp{trialNum} = downsample(procData.disp(:,2),dsFactor,dsPhaseShift);
    
    % Time
    groupedData.dsTime{trialMeta.stimNum} = downsample(Stim.timeVec,dsFactor,dsPhaseShift);

    %% Make stim struct 
    if any(groupedData.stimNum == stimNum)
    else
        StimStruct(stimNum).stimObj = Stim;
    end

    %% Meta data 
    groupedData.stimNum(trialNum) = trialMeta.stimNum;

    %% Calculated data 
    % Take the middle chunk of the trial 
    timeBefore = 0.3;
    pipStartInd = Stim.startPadDur*Stim.sampleRate/dsFactor + 1;
    indBefore = pipStartInd - timeBefore*Stim.sampleRate/dsFactor;
    indAfter = pipStartInd + timeBefore*Stim.sampleRate/dsFactor;
    temp.xDisp = groupedData.xDisp{trialNum}; 
    temp.yDisp = groupedData.yDisp{trialNum};
    % Saved

    groupedData.startChunk.xDisp{trialNum} = temp.xDisp(1:pipStartInd-2);
    groupedData.startChunk.yDisp{trialNum} = temp.yDisp(1:pipStartInd-2);
    
    %% Calculate mean resultant speed for each trial
    groupedData.trialSpeed(trialNum) = mean(sqrt((groupedData.xVel{trialNum}.^2)+(groupedData.yVel{trialNum}.^2)));
    
    %% Clear trial data 
    clear procData temp
end

%% Save data
pPath = getProcessedDataFileName(exptInfo);
mkdir(pPath);
fileName = [pPath,fileNamePreamble,'groupedData.mat'];
save(fileName, 'groupedData','StimStruct');

