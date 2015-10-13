function postMultTrialPlot(metaFileName,figSuffix,varargin)

if ~exist('metaFileName','var')
    [fileName,pathName] = uigetfile;
    metaFileName = fullfile(pathName,fileName); 
end
if ~exist('figSuffix','var')
    figSuffix = 'test';
end

%% Perfrom clicky on each trial 
[greenMov,redMov,~,metaFileName,frameTimes] = loadMeanMovie(metaFileName);
load(metaFileName)
greenCorrected = motionCorrection(greenMov); 
redCorrected = motionCorrection(redMov); 
[roi, greenCountMat, redCountMat] = clickyMult(greenCorrected,redCorrected,Stim,frameTimes,metaFileName,figSuffix);

%% Save plot data 
setpref('scimPlotPrefs','roi',roi);
roiData.roi = roi; 
roiData.greenCountMat = greenCountMat; 
roiData.redCountMat = redCountMat; 
roiData.frameTime = frameTimes; 

[pathName, fileName] = fileparts(metaFileName); 
flyPath = char(regexp(pathName,'.*(?=\\roi)','match'));
fileStem = char(regexp(fileName,'.*(?=trial)','match'));
saveFolder = [flyPath,'\Figures\',figSuffix,'\'];
roiNum = num2str(trialMeta.roiNum,'%03d'); 
blockNum = num2str(trialMeta.blockNum,'%03d'); 
saveFileName = [saveFolder,fileStem,'rois.mat'];
save(saveFileName,'roiData')



