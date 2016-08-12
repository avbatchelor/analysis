function groupPVData(prefixCode,expNum,flyNum,flyExpNum)

exptInfo.prefixCode     = prefixCode;
exptInfo.expNum         = expNum;
exptInfo.flyNum         = flyNum;
exptInfo.flyExpNum      = flyExpNum;
[~, path, fileNamePreamble, ~] = getDataFileNameBall(exptInfo);
cd(path);
dirCont = dir('*trial*');
for i = 1:length(dirCont)
    load(dirCont(i).name);
    trialNum = trialMeta.trialNum;
    settings = ballSettingsWithPV;
    groupedData.stim{trialMeta.stimNum} = Stim.stimulus;
    groupedData.stimTimeVect{trialMeta.stimNum} = Stim.timeVec; 
    groupedData.stimNum(trialNum) = trialMeta.stimNum;
    groupedData.stimStartPadDur{trialMeta.stimNum} = Stim.startPadDur; 
    groupedData.stimDur{trialMeta.stimNum} = Stim.stimDur;
    groupedData.pv{trialNum} = data.pv; 
    groupedData.acqStim1{trialNum} = data.acqStim1;
    groupedData.acqStim2{trialNum} = data.acqStim2;
    groupedData.KEraw{trialNum} = data.KEraw;
    if isfield(Stim,'description')
        groupedData.description{trialMeta.stimNum} = Stim.description;
    else 
        groupedData.description{trialMeta.stimNum} = 'no stim description';
    end
end

fileName = [path,fileNamePreamble,'groupedData.mat'];
save(fileName, 'groupedData','-v7.3');


