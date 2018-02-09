function histTest(prefixCode,expNum,flyNum,flyExpNum)

%% Downsample paramters 
dsFactor = 400;
dsPhaseShift = 200;

%% Make exptInfo struct 
exptInfo = exptInfoStruct(prefixCode,expNum,flyNum,flyExpNum);

%% Get data filenames
[~, path, ~, ~] = getDataFileNameBall(exptInfo);
cd(path);
dirCont = dir('*trial*');

stimSequence = [];

for i = 1:length(dirCont)
    disp(['Trial = ',num2str(i)]);
    
    %% Load data 
    load(dirCont(i).name);
    
    %% Get trial and stim num
    trialNum = trialMeta.trialNum;
    
    % Convert binary matrix to signed integer
    asDec = binaryVectorToDecimal(data.yVelDig,'LSBFirst');
    asDec = asDec - 50;
    
    yVel{trialNum} = asDec; 

end

yMat = cell2mat(yVel);
yMatFlat = yMat(:);
histogram(yMatFlat,unique(yMatFlat))



