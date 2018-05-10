function runAllAnalysisScript(prefixCodes)

for i = 1:size(prefixCodes,1)
    
    prefixCode = prefixCodes{i};
    flies = getFlyExpts(prefixCode);
    
    for j = 1:size(flies,1)
        [prefixCode,expNum,flyNum,flyExpNum] = flies{j,:};
        rotateAndGroupMetaBallData(prefixCode,expNum,flyNum,flyExpNum)
        singleFlyAnalysis(prefixCode,expNum,flyNum,flyExpNum)
    end
end

end

