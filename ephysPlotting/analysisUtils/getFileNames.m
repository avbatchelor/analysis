function [groupedDataFileName,flyDataFileName,exptDataFileName,idString] = getFileNames(exptInfo)

ephysSettings;

[~, path, ~, idString] = getDataFileName(exptInfo);
groupedDataFileName = [path,'groupedData.mat'];

flyDataFileName = [dataDirectory,exptInfo.prefixCode,'\expNum',num2str(exptInfo.expNum,'%03d'),...
    '\flyNum',num2str(exptInfo.flyNum,'%03d'),'\flyData'];

exptDataFileName = [path,idString,'exptData.mat'];
