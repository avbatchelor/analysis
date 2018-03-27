% toAnalyze = {'Freq',2,1,1;'Freq',2,2,1;'Freq',2,3,1;'Freq',2,4,2;'Freq',2,5,1;'Freq',2,6,1;'Freq',2,7,1};
toAnalyze = {'Cardinal',4,1,1;'Cardinal',4,2,2;'Cardinal',4,3,1;'Cardinal',4,4,2;'Cardinal',4,5,3};

for i = 1:length(toAnalyze)
    [prefixCode,expNum,flyNum,flyExpNum] = toAnalyze{i,:};
    allTrials = 'n';
    sameFig = 'y';
    saveQ = 'y';
%     groupBallDataDiffStim(prefixCode,expNum,flyNum,flyExpNum)

    try
    singleFlyAnalysis(prefixCode,expNum,flyNum,flyExpNum)
    plotProcessedBallData(prefixCode,expNum,flyNum,flyExpNum,allTrials,sameFig,saveQ)
    catch 
        disp(['Could not analyze',prefixCode,num2str(expNum),num2str(flyNum),num2str(flyExpNum)])
    end
end