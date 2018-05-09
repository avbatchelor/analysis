function processAndDownsampleBallData(prefixCode,expNum,flyNum,flyExpNum)

%% Load analysis settings  
analysisSettings = getAnalysisSettings;

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
    load(fullfile(path,dirCont(i).name));
    
    %% Get trial and stim num
    trialNum = trialMeta.trialNum;
    
    %% Process data 
    [procData.vel(:,1),procData.disp(:,1)] = processDigBallData(data.xVelDig,Stim,'x',exptInfo);
    [procData.vel(:,2),procData.disp(:,2)] = processDigBallData(data.yVelDig,Stim,'y',exptInfo);
    
    %% Downsample velocity, displacement & time data 
    % Velocity
    groupedData.xVel{trialNum} = downsample(procData.vel(:,1),analysisSettings.dsFactor,analysisSettings.dsPhaseShift);
    groupedData.yVel{trialNum} = downsample(procData.vel(:,2),analysisSettings.dsFactor,analysisSettings.dsPhaseShift);
    
    % Displacement
    groupedData.xDisp{trialNum} = downsample(procData.disp(:,1),analysisSettings.dsFactor,analysisSettings.dsPhaseShift);
    groupedData.yDisp{trialNum} = downsample(procData.disp(:,2),analysisSettings.dsFactor,analysisSettings.dsPhaseShift);
    
    % Time
    groupedData.dsTime{trialMeta.stimNum} = downsample(Stim.timeVec,analysisSettings.dsFactor,analysisSettings.dsPhaseShift);

    %% Clear trial data 
    clear procData temp
end

groupedData.processedDate = checkRepoStatus;

%% Save data
pPath = getProcessedDataFileName(exptInfo);
mkdir(pPath);
fileName = [pPath,fileNamePreamble,'processedAndDownsampledData.mat'];
save(fileName,'groupedData');
