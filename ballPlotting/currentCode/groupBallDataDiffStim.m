function groupBallDataDiffStim(prefixCode,expNum,flyNum,flyExpNum)

%% Downsample paramters 
dsFactor = 400;
dsPhaseShift = 200;

%% Make exptInfo struct 
exptInfo = exptInfoStruct(prefixCode,expNum,flyNum,flyExpNum);

%% Get data filenames
[~, path, fileNamePreamble, ~] = getDataFileNameBall(exptInfo);
cd(path);
dirCont = dir('*trial*');

stimSequence = [];

for i = 1:length(dirCont)
    disp(['Trial = ',num2str(i)]);
    
    %% Load data 
    load(dirCont(i).name);
    
    %% Get trial and stim num
    trialNum = trialMeta.trialNum;
    stimNum = trialMeta.stimNum;
    
    %% Process data 
    [procData.vel(:,1),procData.disp(:,1)] = processDigBallData(data.xVelDig,Stim);
    [procData.vel(:,2),procData.disp(:,2)] = processDigBallData(data.yVelDig,Stim);
    
    %% Downsample velocity and displacement data 
    groupedData.xVel{trialNum} = downsample(procData.vel(:,1),dsFactor,dsPhaseShift);
    groupedData.yVel{trialNum} = downsample(procData.vel(:,2),dsFactor,dsPhaseShift);
    groupedData.xDisp{trialNum} = downsample(procData.disp(:,1),dsFactor,dsPhaseShift);
    groupedData.yDisp{trialNum} = downsample(procData.disp(:,2),dsFactor,dsPhaseShift);
    
    %% Time data
    groupedData.dsTime{trialMeta.stimNum} = downsample(Stim.timeVec,400,200);
    groupedData.stimTimeVect{trialMeta.stimNum} = Stim.timeVec; 

    %% Stimulus data 
    groupedData.stim{trialMeta.stimNum} = Stim.stimulus;
    if exist('LEDtrig','var')
        groupedData.led{trialMeta.stimNum} = LEDtrig.stimulus;
    end
    
    %% Make stim struct 
    if any(stimSequence == stimNum)
    else
        StimStruct(stimNum).stimObj = Stim;
    end
    
    % Record stim num sequenceata matrix
    stimSequence = [stimSequence, stimNum];

    %% Meta data 
    groupedData.stimNum(trialNum) = trialMeta.stimNum;
    if isfield(Stim,'carrierFreqHz')
        groupedData.stimFreq(trialMeta.stimNum) = Stim.carrierFreqHz;
    else 
        groupedData.stimFreq(trialMeta.stimNum) = 0;
    end
    groupedData.stimStartPadDur{trialMeta.stimNum} = Stim.startPadDur; 
    groupedData.stimDur{trialMeta.stimNum} = Stim.stimDur;
    % Take the middle chunk of the trial 
    timeBefore = 0.3;
    pipStartInd = Stim.startPadDur*Stim.sampleRate/dsFactor + 1;
    indBefore = pipStartInd - timeBefore*Stim.sampleRate/dsFactor;
    indAfter = pipStartInd + timeBefore*Stim.sampleRate/dsFactor;
    temp.xDisp = groupedData.xDisp{trialNum}; 
    temp.yDisp = groupedData.yDisp{trialNum};
    groupedData.midChunk.xDisp{trialNum} = temp.xDisp(indBefore:indAfter);
    groupedData.midChunk.yDisp{trialNum} = temp.yDisp(indBefore:indAfter);
    groupedData.startChunk.xDisp{trialNum} = temp.xDisp(1:pipStartInd-2);
    groupedData.startChunk.yDisp{trialNum} = temp.yDisp(1:pipStartInd-2);
    
    %% Find indices of trials that where running speed is too slow/fast  
    Vxy = sqrt((groupedData.xVel{trialNum}.^2)+(groupedData.yVel{trialNum}.^2));
    avgResultantVelocity = mean(Vxy);
    groupedData.trialSpeed(trialNum) = avgResultantVelocity;
    clear procData temp
end

%% Save data
pPath = getProcessedDataFileName(exptInfo);
mkdir(pPath);
fileName = [pPath,fileNamePreamble,'groupedData.mat'];
save(fileName, 'groupedData','StimStruct');




