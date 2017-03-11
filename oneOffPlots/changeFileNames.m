function changeFileNames(prefixCode,expNum,flyNum,cellNum,remerge,replot,varargin)

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
    for j = 1:length(cellExpNumList)
        exptInfo.cellExpNum = str2num(char(regexp(cellExpNumList(j).name,'(?<=cellExpNum).*','match')));
%% Change file names 
%         [~,path] = getDataFileName(exptInfo);
%         cd(path);
%         fileNames = dir('*trial*.mat');
%         numTrials = length(fileNames);
%         for k = 1:numTrials 
%             oldFileName = fullfile(path,fileNames(k).name);
%             newFileName = strrep(oldFileName,'flyNum001','flyNum002');
%             movefile(oldFileName,newFileName);
%         end
%% Change exptInfo in exptData 
%         if j ~= 3
%             [~,~,exptDataFileName,~] = getFileNames(exptInfo);
%             load(exptDataFileName)
%             exptInfo.flyNum = 2; 
%             save(exptDataFileName,'exptInfo','preExptData','settings')
%         end
%% Change exptInfo for individual trials 
        [~,path] = getDataFileName(exptInfo);
        cd(path);
        fileNames = dir('*trial*.mat');
        numTrials = length(fileNames);
        for k = 1:numTrials 
            fileName = fullfile(path,fileNames(k).name);
            load(fileName)
            exptInfo.flyNum = 2; 
            save(fileName,'data','exptInfo','Stim','trialMeta')
        end
    end
end
