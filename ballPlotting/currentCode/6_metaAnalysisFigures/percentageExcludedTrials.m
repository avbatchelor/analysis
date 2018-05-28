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

        numTrials = max(groupedData.trialNum);
        numFast = length(groupedData.fastEnoughTrials);
        numSaturated = length(groupedData.saturatedTrials);
        percentageSlow{dataIdx} = 100*((numTrials - numFast)/numTrials);
        percentageSaturated{dataIdx} = 100*(numSaturated/numFast);

    end
end

% disp(['Mean temp = ',num2str(mean(temp))])
% disp(['Min temp = ',num2str(min(temp))])
% disp(['Max temp = ',num2str(max(temp))])


