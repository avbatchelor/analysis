function plotAllExpts(prefixCode,expNum,flyNum)

% Merges trials and plots data grouped by stimulus for each cell and cell
% experiments for a fly

%% Ask which cellExps are probe experiments 
x = inputdlg('Enter probe experiments (space-separated numbers):',...
             'Sample', [1 50]);
probeExpts = str2num(x{:}); 

%% Create exptInfo
exptInfo.prefixCode     = prefixCode;
exptInfo.expNum         = expNum;
exptInfo.flyNum         = flyNum;
exptInfo.cellNum        = 1;
exptInfo.cellExpNum     = 1; 

%% Run analysis files 
[~,path] = getDataFileName(exptInfo);
cellFileStem = char(regexp(path,'.*(?=cellNum)','match'));
cd(cellFileStem); 
cellNumList = dir('cellNum*');
for i = 1:length(cellNumList)
    exptInfo.cellNum = str2num(char(regexp(cellNumList(i).name,'(?<=cellNum).*','match')));
    [~,path] = getDataFileName(exptInfo);
    cellExpFileStem = char(regexp(path,'.*(?=cellExpNum)','match'));
    cd(cellExpFileStem);
    cellExpNumList = dir('cellExpNum*');
    for j = 1:length(cellExpNumList)
        exptInfo.cellExpNum = str2num(char(regexp(cellExpNumList(j).name,'(?<=cellExpNum).*','match')));
        [~,path] = getDataFileName(exptInfo);
        cd(path);
        fileNames = dir('*trial*.mat');
        numTrials = length(fileNames);
        if numTrials == 0
        else 
            mergeTrials(exptInfo)
            plotZeroCurrentTrial(exptInfo)
            if ~any(j == probeExpts)
                plotDataGroupedByStim(exptInfo)
            else
                plotDataGroupedByProbePosition(exptInfo.prefixCode,exptInfo.expNum,exptInfo.flyNum,exptInfo.cellNum,exptInfo.cellExpNum)
                plotProbeDiffFigForRepeat(exptInfo.prefixCode,exptInfo.expNum,exptInfo.flyNum,exptInfo.cellNum,exptInfo.cellExpNum)
            end
        end
    end
end

flyFolder = char(regexp(path,'.*(?=cellNum)','match'));
groupAllPdfs([flyFolder,'Figures'])