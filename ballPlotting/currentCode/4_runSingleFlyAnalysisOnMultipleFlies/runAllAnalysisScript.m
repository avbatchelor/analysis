% prefixCodes = {'Freq';'Males';'a2Glued';'a3Glued';'ShamGlued-45';...
%     'RightGlued';'LeftGlued';'ShamGlued-0';'Diag';'Cardinal'};

prefixCodes = {'Cardinal-0'};

for i = 1:size(prefixCodes,1)
    
    prefixCode = prefixCodes{i};
    flies = getFlyExpts(prefixCode);
    
    for j = 1:size(flies,1)
        [prefixCode,expNum,flyNum,flyExpNum] = flies{j,:};
        disp(['Analyzing ',prefixCode,' fly ',num2str(j)])
        rotateAndGroupMetaBallData(prefixCode,expNum,flyNum,flyExpNum)
        singleFlyAnalysis(prefixCode,expNum,flyNum,flyExpNum)
    end
end



