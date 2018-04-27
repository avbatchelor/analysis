function numFastTrials = numAboveThresholdTrials(prefixCode,threshold)

flies = getFlyExpts(prefixCode);

%% Loop through flies 
for i = 1:size(flies,1)
    %% Load data 
    [prefixCode,expNum,flyNum,flyExpNum] = flies{i,:};
    exptInfo = exptInfoStruct(prefixCode,expNum,flyNum,flyExpNum);
    [groupedData,~] = loadProcessedData(exptInfo);
    for j = unique(groupedData.stimNum)
        numFastTrials(i,j) = sum(groupedData.trialSpeed(groupedData.stimNum==j) > threshold);
    end
    if strcmp(prefixCode,'Males')
        numFastTrials(1,3) = nan;
    end
end