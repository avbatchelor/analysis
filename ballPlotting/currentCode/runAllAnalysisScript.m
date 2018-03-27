toAnalyze = {'Cardinal',4,1,1;'Cardinal',4,2,2;'Cardinal',4,3,1;'Cardinal',4,4,2;'Cardinal',4,5,3};

for i = 1:length(toAnalyze)
    [prefixCode,expNum,flyNum,flyExpNum] = toAnalyze{i,:};
    allTrials = 'n';
    sameFig = 'y';
    saveQ = 'y';
    try
        groupBallDataDiffStim(prefixCode,expNum,flyNum,flyExpNum)
    catch 
        disp(['Could not analyze',prefixCode,num2str(expNum),num2str(flyNum),num2str(flyExpNum)])
    end
        %     singleFlyAnalysis(prefixCode,expNum,flyNum,flyExpNum)
%     plotProcessedBallData(prefixCode,expNum,flyNum,flyExpNum,allTrials,sameFig,saveQ)
end

