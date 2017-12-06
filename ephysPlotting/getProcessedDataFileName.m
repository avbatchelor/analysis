function pPath = getProcessedDataFileName(exptInfo)

[~, path, ~, ~] = getDataFileNameBall(exptInfo);

pPath = strrep(path, '\Data\', '\ProcessedData\');

