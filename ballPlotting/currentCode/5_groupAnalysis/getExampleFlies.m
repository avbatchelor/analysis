function [groupedData,plotData,StimStruct] = getExampleFlies(prefixCode)

switch prefixCode
    % Fig 1
    % n/a
    
    % Fig 2
    case 'Freq'
        flies = {'Freq',2,2,1};
        
        % Fig 3
    case 'Males'
        flies = {'Males',1,1,1};
        
        % Fig 4
    case 'a2Glued'
        flies = {'a2Glued',1,1,1};
    case 'a3Glued'
        flies = {'a3Glued',1,2,1};
    case 'ShamGlued-45'
        flies = {'ShamGlued',1,1,2};
        
        % Fig 5
        % n/a
        
        % Fig 6
    case 'RightGlued'
        flies = {'RightGlued',1,1,1};
    case 'LeftGlued'
        flies = {'LeftGlued',1,1,1};
    case 'ShamGlued-0'
        flies = {'ShamGlued',1,1,1};
        
        % Fig 7
    case 'Diag'
        flies = {'Diag',1,1,2};
        
        % Fig 8
    case 'Cardinal'
        flies = {'Cardinal',5,2,3};
        
end

%% Load data 
% Make expt info
[prefixCode,expNum,flyNum,flyExpNum] = flies{:};
    
% Put exptInfo in a struct
exptInfo = exptInfoStruct(prefixCode,expNum,flyNum,flyExpNum);

% Get paths
[~, ~, fileNamePreamble, ~] = getDataFileNameBall(exptInfo);
pPath = getProcessedDataFileName(exptInfo);

% Plot data
fileName = [pPath,fileNamePreamble,'plotData.mat'];
load(fileName);

% Grouped data
fileName = [pPath,fileNamePreamble,'groupedData.mat'];
load(fileName);


end