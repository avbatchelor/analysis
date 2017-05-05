function plotAllExpts(prefixCode,expNum,flyNum,cellNum,remerge,replot,cellExpNumToPlot,varargin)

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

%% Work out whether to plot all cellExpts 
if ~exist('cellExpNumToPlot','var')
    cellExpNumToPlot = 0;
end


%% Create exptInfo
exptInfo = makeExptInfoStruct(prefixCode,expNum,flyNum,1,1);

%% Loops through cells and cell experiments, merge trials and run analysis 
[~,path] = getDataFileName(exptInfo);
cellFileStem = char(regexp(path,'.*(?=cellNum)','match'));
cd(cellFileStem); 
cellNumList = dir('cellNum*');
if exist('cellNum','var')
    cellNumList = cellNum;
end
for i = 1:length(cellNumList)
    if exist('cellNum','var')
        exptInfo.cellNum = cellNum;
    else 
        exptInfo.cellNum = str2num(char(regexp(cellNumList(i).name,'(?<=cellNum).*','match')));
    end
    [~,path] = getDataFileName(exptInfo);
    cellExpFileStem = char(regexp(path,'.*(?=cellExpNum)','match'));
    cd(cellExpFileStem);
    cellExpNumList = dir('cellExpNum*');
    if cellExpNumToPlot == 0 
        cellExpNumListToPlot = 1:length(cellExpNumList);
    else 
        cellExpNumListToPlot = cellExpNumToPlot; 
    end
    for j = cellExpNumListToPlot
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
%             % Convert tiffs to videos 
%             aviFromTiff(exptInfo)
%             % Calculate optic flow 
%             calculateOpticFlow(exptInfo)
            %% Make figures
            if replot == 1 
                plotZeroCurrentTrial(exptInfo)
                if any(stimSet == [19,29]) % run different code for probe experiments 
                    plotDataGroupedByProbePosition(exptInfo.prefixCode,exptInfo.expNum,exptInfo.flyNum,exptInfo.cellNum,exptInfo.cellExpNum)
                    plotProbeDiffFigForRepeat(exptInfo.prefixCode,exptInfo.expNum,exptInfo.flyNum,exptInfo.cellNum,exptInfo.cellExpNum)
                elseif stimSet == 21 
                    plotMean(exptInfo)
                else 
                    plotDataGroupedByStim(exptInfo)
                end
                if any(stimSet == [20,24,25]) 
                    plotTuningCurve(exptInfo.prefixCode,exptInfo.expNum,exptInfo.flyNum,exptInfo.cellNum,exptInfo.cellExpNum)
                end
            end
        end
    end
end

% %% Group pdfs
% flyFolder = char(regexp(path,'.*(?=cellNum)','match'));
% groupAllPdfs([flyFolder,'Figures'])