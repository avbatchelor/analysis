function plotAllExpts(prefixCode,expNum,flyNum,remerge,replot,varargin)

% Merges trials and plots data grouped by stimulus for each cell and cell
% experiments for a fly

%% Work out whether to remerge trials
if ~exist('remerge','var')
    remerge = 0;
end

%% Work out whether to replot figures 
if ~exist('replot','var')
    replot = 0;
end

%% Create exptInfo
exptInfo = makeExptInfoStruct(prefixCode,expNum,flyNum,1,1);

%% Loops through cells and cell experiments, merge trials and run analysis 
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
        if exptInfo.cellExpNum ==1 && numTrials == 0
            plotZeroCurrentTrial(exptInfo)
        elseif numTrials == 0 
        else 
            %% Load exptInfo file 
            [~,~,exptDataFileName,~] = getFileNames(exptInfo);
            load(exptDataFileName)
            stimSet = exptInfo.stimSetNum;
            %% Merge trials
            mergeTrials(exptInfo,remerge)
            %% Make figures
            if replot == 1 
%                 plotZeroCurrentTrial(exptInfo)
%                 if stimSet == 19 % run different code for probe experiments 
%                     plotDataGroupedByProbePosition(exptInfo.prefixCode,exptInfo.expNum,exptInfo.flyNum,exptInfo.cellNum,exptInfo.cellExpNum)
%                     plotProbeDiffFigForRepeat(exptInfo.prefixCode,exptInfo.expNum,exptInfo.flyNum,exptInfo.cellNum,exptInfo.cellExpNum)
%                 else 
%                     plotDataGroupedByStim(exptInfo)
%                 end
%                 if any(stimSet == [20,24]) 
%                     plotTuningCurve(exptInfo.prefixCode,exptInfo.expNum,exptInfo.flyNum,exptInfo.cellNum,exptInfo.cellExpNum)
%                 end
            end
        end
    end
end

%% Group pdfs
% flyFolder = char(regexp(path,'.*(?=cellNum)','match'));
% groupAllPdfs([flyFolder,'Figures'])