clear all

prefixCodes = {'Freq';'Males';'a2Glued';'a3Glued';'ShamGlued-45';...
    'RightGlued';'LeftGlued';'Diag';'Cardinal';'Cardinal-0'};

dataIdx = 0;

for i = 1:size(prefixCodes,1)
    
    prefixCode = prefixCodes{i};
    flies = getFlyExpts(prefixCode);
    
    for j = 1:size(flies,1)
        dataIdx = dataIdx + 1;
        [prefixCode,expNum,flyNum,flyExpNum] = flies{j,:};
        exptInfo = exptInfoStruct(prefixCode,expNum,flyNum,flyExpNum);
        
        % Get raw data paths 
        [~, path, fileNamePreamble, ~] = getDataFileNameBall(exptInfo);
        cd(path);
        dirCont = dir('*trial*');
        
        % Loop through trials, process and save
        groupedData.stimNum = [];
                
        %% Load last trial 
        [~, ~, fileNamePreamble, ~] = getDataFileNameBall(exptInfo);
        pPath = getProcessedDataFileName(exptInfo);
        
        % Grouped data
        fileName = [pPath,fileNamePreamble,'groupedData.mat'];
        load(fileName);
        
        lastFastTrial(dataIdx) = max(groupedData.selectedTrials);
        
%         lastFastTrialFileName = [path,fileNamePreamble,'trial',num2str(lastFastTrial,'%03d')];
%         load(lastFastTrialFileName);
        
        %% Get experiment start time 
%         
%                         
%             if regexp(trialMeta.trialStartTime,'00.*')
%                 day = num2str(str2num(exptInfo.dNum) + 1);
%             else
%                 day = exptInfo.dNum;
%             end
%             
%             trialStartStr = [day,' ',trialMeta.trialStartTime];
%             trialStarts(trial,:) = datevec(trialStartStr,'yyMMdd HH:mm:ss');
%         end
%         
%         for trial = 1:length(dirCont)-1
%             ITI(trial) = etime(trialStarts(trial+1,:),trialStarts(trial,:));
%         end
%         
%         meanITI = mean(ITI);
        
    end
end