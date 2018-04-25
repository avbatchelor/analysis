function date = lookupDate(exptInfo)

    % Get the date of an experiment 
    
    % Get the path 
    [~, path, fileNamePreamble, ~] = getDataFileNameBall(exptInfo);

    % Load exptInfo
    load(fullfile(path,[fileNamePreamble,'exptData']))
    
    date = exptInfo.dNum;