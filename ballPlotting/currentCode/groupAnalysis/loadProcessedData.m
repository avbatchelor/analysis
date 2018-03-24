function [groupedData,StimStruct] = loadProcessedData(exptInfo)

[~, ~, fileNamePreamble, ~] = getDataFileNameBall(exptInfo);
pPath = getProcessedDataFileName(exptInfo);

% Grouped data
fileName = [pPath,fileNamePreamble,'groupedData.mat'];
S = load(fileName);
groupedData = S.groupedData; 
StimStruct = S.StimStruct;

end