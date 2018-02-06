function postHocPlotAllExptsDs(prefixCode,expNum,flyNum)

exptInfo.prefixCode     = prefixCode;
exptInfo.expNum         = expNum;
exptInfo.flyNum         = flyNum;
exptInfo.flyExpNum      = 1;
[~, path, ~, ~] = getDataFileNameBall(exptInfo);
fileStem = char(regexp(path,'.*(?=flyExpNum)','match'));
cd(fileStem); 
expNumList = dir('flyExp*');
for i = 1:length(expNumList)
    flyExpNum = str2num(char(regexp(expNumList(i).name,'(?<=flyExpNum).*','match')));
    if strcmp(prefixCode,'rotRep') && expNum <= 9
        plotBallDataPostHocDs(prefixCode,expNum,flyNum,flyExpNum)
    elseif strcmp(prefixCode,'38F12-in') && expNum == 1
        plotBallDataDiffStimSameFigUnpaired(prefixCode,expNum,flyNum,flyExpNum)
    else
        plotBallDataDiffStimSameFig(prefixCode,expNum,flyNum,flyExpNum,'n')
    end
end

groupPdfs([fileStem,'Figures'])
