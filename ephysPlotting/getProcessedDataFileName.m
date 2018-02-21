function pPath = getProcessedDataFileName(exptInfo)

[~, path, ~, ~] = getDataFileNameBall(exptInfo);

computer = getComputerID;
if strcmp(computer,'behavior')
    pPath = strrep(path, '\Data\', '\ProcessedData\');
elseif strcmp(computer,'desktop')
    pPath = strrep(path, 'rawData\', 'processedData\');
end
