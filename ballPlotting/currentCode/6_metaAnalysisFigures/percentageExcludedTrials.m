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
        
        [~, ~, fileNamePreamble, ~] = getDataFileNameBall(exptInfo);
        pPath = getProcessedDataFileName(exptInfo);

        % Grouped data
        fileName = [pPath,fileNamePreamble,'groupedData.mat'];
        load(fileName);

        lastFastTrial = max(groupedData.selectedTrials);
        slowTrials = setdiff(groupedData.trialNum,groupedData.selectedTrials);
        numSlowTrialsBeforeLastFastTrial = sum(slowTrials<lastFastTrial);
        numSatTrialsBeforeLastFastTrial = sum(groupedData.saturatedTrials<lastFastTrial);
        
        numTrials = max(groupedData.trialNum);
        numFast = length(groupedData.fastEnoughTrials);
        numSaturated = numFast - length(groupedData.selectedTrials);
%         percentageSlowTotal(dataIdx) = 100*((numTrials - numFast)/numTrials);
        
        percentageSlowBefore(dataIdx) = 100*numSlowTrialsBeforeLastFastTrial/lastFastTrial;
        percentageSatBefore(dataIdx) = 100*numSatTrialsBeforeLastFastTrial/numFast;
        
        clear fastTrialsPerStim
        for stimNum = unique(groupedData.stimNum)
            fastTrialsPerStim(stimNum) = length(intersect(groupedData.selectedTrials,find(groupedData.stimNum == stimNum)));
        end     
        numTrialsPerFly(dataIdx) = min(fastTrialsPerStim);

    end
end

disp(['Mean slow = ',num2str(mean(percentageSlowBefore))])
disp(['Min slow = ',num2str(min(percentageSlowBefore))])
disp(['Max slow = ',num2str(max(percentageSlowBefore))])

disp(['Mean sat = ',num2str(mean(percentageSatBefore))])
disp(['Min sat = ',num2str(min(percentageSatBefore))])
disp(['Max sat = ',num2str(max(percentageSatBefore))])

disp(['Mean num trials = ',num2str(mean(numTrialsPerFly))])
disp(['Min num trials = ',num2str(min(numTrialsPerFly))])
disp(['Max num trials = ',num2str(max(numTrialsPerFly))])
