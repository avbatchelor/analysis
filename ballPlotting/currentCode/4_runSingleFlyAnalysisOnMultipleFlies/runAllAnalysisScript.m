prefixCode = 'ShamGlued-45';

flies = getFlyExpts(prefixCode);

for i = 1:size(flies,1)
    [prefixCode,expNum,flyNum,flyExpNum] = flies{i,:};
    allTrials = 'n';
    sameFig = 'y';
    saveQ = 'y';
%     try
% %         processAndDownsampleBallData(prefixCode,expNum,flyNum,flyExpNum)
%     catch 
%         disp(['Could not analyze',prefixCode,num2str(expNum),num2str(flyNum),num2str(flyExpNum)])
%     end
    rotateAndGroupMetaBallData(prefixCode,expNum,flyNum,flyExpNum)
    singleFlyAnalysis(prefixCode,expNum,flyNum,flyExpNum)
        %     singleFlyAnalysis(prefixCode,expNum,flyNum,flyExpNum)
%     plotProcessedBallData(prefixCode,expNum,flyNum,flyExpNum,allTrials,sameFig,saveQ)
end

