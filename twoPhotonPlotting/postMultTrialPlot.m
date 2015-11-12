function postMultTrialPlot(metaFileName,figSuffix,varargin)

if ~exist('metaFileName','var')
    [fileName,pathName] = uigetfile;
    metaFileName = fullfile(pathName,fileName); 
end

[pathName, fileName] = fileparts(metaFileName); 
flyPath = char(regexp(pathName,'.*(?=\\roi)','match'));
fileStem1 = char(regexp(fileName,'.*(?=roi)','match'));
fileStem2 = char(regexp(fileName,'.*(?=trial)','match'));

if ~exist('figSuffix','var')
    figSuffix = 'Offline';
    folderCount = 1; 
    saveFolder = [flyPath,'\Figures\',figSuffix,num2str(folderCount,'%03d'),'\']; 
    while isdir(saveFolder) 
        folderCount = folderCount + 1;
        saveFolder = [flyPath,'\Figures\',figSuffix,num2str(folderCount,'%03d'),'\']; 
    end
else 
    saveFolder = [flyPath,'\Figures\',figSuffix,'\']; 
end

analysisDataFileName = [saveFolder,fileStem1,'analysisData.mat'];
traceDataFileName = [saveFolder,fileStem2,'traceData.mat'];

%% Perfrom clicky on each trial 
[greenMov,redMov,frameRate,metaFileName,frameTimes] = loadMeanMovie(metaFileName);
load(metaFileName)
greenCorrected = motionCorrection(greenMov,metaFileName,frameTimes); 
redCorrected = motionCorrection(redMov,metaFileName); 

%% Perfrom kmeans
[analysisData,kmeansData] = kmeansMult(greenCorrected,redCorrected, Stim, frameTimes,metaFileName,figSuffix,frameRate,analysisDataFileName);
[analysisData,roiData] = clickyMult(greenCorrected,redCorrected,Stim,frameTimes,metaFileName,figSuffix,analysisDataFileName);

%% Save ROI and cluster data
roiData.frameTime = frameTimes; 
save(analysisDataFileName,'analysisData')

%% Save trace data 
save(traceDataFileName,'roiData','kmeansData')



