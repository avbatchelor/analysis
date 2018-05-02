% toAnalyze = {'Cardinal',4,1,1;'Cardinal',4,2,2;'Cardinal',4,3,1;'Cardinal',4,4,2;'Cardinal',4,5,3};
% toAnalyze = {'Cardinal',5,1,3;'Cardinal',5,2,3;'Cardinal',4,1,1;'Cardinal',4,2,2;'Cardinal',4,3,1;'Cardinal',4,4,2;'Cardinal',4,5,3};
% toAnalyze = {'Cardinal',5,2,3;'Cardinal',5,3,3;'Cardinal',5,4,4;'Cardinal',5,5,4;'Cardinal',5,6,7};
% toAnalyze = {'Cardinal',5,6,7};
toAnalyze = {'Cardinal',5,2,3;'Cardinal',5,3,3;'Cardinal',5,4,4;'Cardinal',5,5,4;'Cardinal',5,6,7};

for i = 1:length(toAnalyze)
    [prefixCode,expNum,flyNum,flyExpNum] = toAnalyze{i,:};
    allTrials = 'n';
    sameFig = 'y';
    saveQ = 'y';
    %     groupBallDataDiffStim(prefixCode,expNum,flyNum,flyExpNum)
    
%     try
        rotateAndGroupMetaBallData(prefixCode,expNum,flyNum,flyExpNum)
        singleFlyAnalysis(prefixCode,expNum,flyNum,flyExpNum,0)
%         plotProcessedBallData(prefixCode,expNum,flyNum,flyExpNum,'n','y','y',0)
%         plotBlocksSingleFly(prefixCode,expNum,flyNum,flyExpNum,'n','n','y',0)
%         labelSaturatedTimePoints(prefixCode,expNum,flyNum,flyExpNum)
%     catch
%         disp(['Could not analyze',prefixCode,num2str(expNum),num2str(flyNum),num2str(flyExpNum)])
%     end
end