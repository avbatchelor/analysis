runAllAnalysis(

toAnalyze = {'ShamGlued',1,1,1;



function runAllAnalysis(prefixCode,expNum,flyNum,flyExpNum)

allTrials = 'n';
sameFig = 'y';
groupBallDataDiffStim(prefixCode,expNum,flyNum,flyExpNum)
singleFlyAnalysis(prefixCode,expNum,flyNum,flyExpNum)
plotProcessedBallData(prefixCode,expNum,flyNum,flyExpNum,allTrials,sameFig)

end
