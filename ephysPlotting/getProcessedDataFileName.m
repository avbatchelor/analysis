function pPath = getProcessedDataFileName(exptInfo)

[~, path, ~, ~] = getDataFileName(exptInfo);

pPath = strrep(path, 'DataD', 'ProcessedDataD');


