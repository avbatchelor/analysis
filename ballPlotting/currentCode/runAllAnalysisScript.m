toAnalyze = {'ShamGlued',1,2,1;'ShamGlued',1,2,2;'ShamGlued',1,3,1;'ShamGlued',1,3,2};

% toAnalyze = {'RightGlued',1,1,1;'RightGlued',1,2,1;'RightGlued',1,3,1;'RightGlued',1,4,1;'RightGlued',1,5,2;...
%     'LeftGlued',1,1,1;'LeftGlued',1,2,3;'LeftGlued',1,3,5;'LeftGlued',1,4,1;'LeftGlued',1,5,3};

for i = 1:length(toAnalyze)
    [prefixCode,expNum,flyNum,flyExpNum] = toAnalyze{i,:};
    allTrials = 'n';
    sameFig = 'y';
    saveQ = 'y';
    groupBallDataDiffStim(prefixCode,expNum,flyNum,flyExpNum)
%     singleFlyAnalysis(prefixCode,expNum,flyNum,flyExpNum)
%     plotProcessedBallData(prefixCode,expNum,flyNum,flyExpNum,allTrials,sameFig,saveQ)
end

