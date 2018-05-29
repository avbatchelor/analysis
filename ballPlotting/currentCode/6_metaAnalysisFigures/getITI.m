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
        
        for trial = 1:length(dirCont)
            
            %% Load data
            load(fullfile(path,dirCont(trial).name));
                       
            if regexp(trialMeta.trialStartTime,'0.*')
                day = num2str(str2num(exptInfo.dNum) + 1);
            else
                day = exptInfo.dNum;
            end
            
            trialStartStr = [day,' ',trialMeta.trialStartTime];
            trialStarts(trialMeta.trialNum,:) = datevec(datenum(trialStartStr,'yymmdd HH:MM:SS'));
            
            if trial ~= 1
                ITI(trial-1) = etime(trialStarts(trial,:),trialStarts(trial-1,:));
                if ITI(trial-1)>50 
                    error('')
                end
            end
            
            
        end
        
        disp(['Mean ITI = ',num2str(mean(ITI))])
        disp(['Median ITI = ',num2str(median(ITI))])
        disp(['Min ITI = ',num2str(min(ITI))])
        disp(['Max ITI = ',num2str(max(ITI))])
        
    end
end