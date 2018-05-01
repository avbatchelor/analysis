toAnalyze = {'Cardinal',5,4,4;'Cardinal',5,5,4;'Cardinal',5,6,7};

for i = 1:length(toAnalyze)
    [prefixCode,expNum,flyNum,flyExpNum] = toAnalyze{i,:};
    allTrials = 'n';
    sameFig = 'y';
    saveQ = 'y';
    try
%         groupBallDataDiffStim(prefixCode,expNum,flyNum,flyExpNum)
        processAndDownsampleBallData(prefixCode,expNum,flyNum,flyExpNum)
    catch 
        disp(['Could not analyze',prefixCode,num2str(expNum),num2str(flyNum),num2str(flyExpNum)])
    end
        %     singleFlyAnalysis(prefixCode,expNum,flyNum,flyExpNum)
%     plotProcessedBallData(prefixCode,expNum,flyNum,flyExpNum,allTrials,sameFig,saveQ)
end

