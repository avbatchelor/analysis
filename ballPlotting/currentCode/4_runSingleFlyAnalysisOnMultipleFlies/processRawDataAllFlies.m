prefixCodes = {'Males';'Freq'};

for j = 1:size(prefixCodes,1)

    prefixCode = prefixCodes{1};
    flies = getFlyExpts(prefixCode);

    for i = 1:size(flies,1)
        [prefixCode,expNum,flyNum,flyExpNum] = flies{i,:};
        disp(['Analyzing ',prefixCode,' fly ',num2str(flyNum)])
        processAndDownsampleBallData(prefixCode,expNum,flyNum,flyExpNum)
    end
    
end