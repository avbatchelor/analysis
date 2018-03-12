toAnalyze = {'ShamGlued',1,2,1;'ShamGlued',1,2,2;'ShamGlued',1,3,1;'ShamGlued',1,3,2};

for i = 1:length(toAnalyze)
    [prefixCode,expNum,flyNum,flyExpNum] = toAnalyze{i,:};
    allTrials = 'n';
    sameFig = 'y';
    saveQ = 'y';
%     groupBallDataDiffStim(prefixCode,expNum,flyNum,flyExpNum)
    singleFlyAnalysis(prefixCode,expNum,flyNum,flyExpNum)
    plotProcessedBallData(prefixCode,expNum,flyNum,flyExpNum,allTrials,sameFig,saveQ)
end